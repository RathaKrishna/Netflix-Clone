//
//  MovieDetailsViewController.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 31/05/22.
//

import UIKit
import WebKit

class MovieDetailsViewController: UIViewController {
    
    
    private var viewModels = [MovieViewModel]()
    private var movie: Movie
    
    let sectionTitles: [String] = ["Recommended Movies", "Similar Movies"]
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    private let descLabel: UILabel = {
        let label = UILabel()
        //        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    private let playerView: WKWebView = {
        let webview = WKWebView()
        return webview
    }()
    
    private let tableView: UITableView = {
        let tablView = UITableView(frame: .zero, style: .grouped)
        tablView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return tablView
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "square.and.arrow.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        //        button.setTitleColor(UIColor.label, for: .normal)
        //        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        //        button.layer.borderWidth = 0.8
        //        button.layer.cornerRadius = 3
        return button
    }()
    
    private let summaryBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Summary >>", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.layer.cornerRadius = 12
        return button
    }()
    
    init(with model: Movie) {
        self.movie = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(titleLable)
        view.addSubview(summaryBtn)
        view.addSubview(downloadButton)
        view.addSubview(playerView)
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        update()
        getUpMovies()
        getYoutubeVideo()
        navigationController?.navigationBar.tintColor = .label
        
        summaryBtn.addTarget(self, action: #selector(summaryClicked), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.bounds.height/4)
        }
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(playerView.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        summaryBtn.snp.makeConstraints { make in
            make.right.equalTo(downloadButton.snp.left).offset(-10)
            make.top.equalTo(downloadButton)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        titleLable.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(summaryBtn.snp.left).offset(-5)
            make.top.equalTo(playerView.snp.bottom).offset(10)
        }
        
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(playerView)
            make.top.equalTo(titleLable.snp.bottom).offset(15)
            make.bottom.equalTo(view.safeAreaInsets.bottom)
        }
        
        
    }
    
    
    private func getUpMovies() {
        APICaller.shared.getMoviesData(with: Constants.trendingMovies) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.viewModels = movies.compactMap({
                        MovieViewModel(imgUrl: "\(Constants.thumbnailImage)\($0.poster_path ?? "")", title: $0.title ?? "", overview: $0.overview, voteCount: $0.vote_count, releaseDate: $0.release_date ?? "", voteAverage: $0.vote_average)
                    })
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    private func getYoutubeVideo() {
        guard let title = movie.original_title ?? movie.original_name else { return }
        
        APICaller.shared.getMovie(with: "\(title) trailer") {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let videoItem):
                    print(videoItem.id)
                    guard let url = URL(string: "https://www.youtube.com/embed/\(videoItem.id.videoId)") else {
                        return
                    }
                    
                    self?.playerView.load(URLRequest(url: url))
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    private func update() {
        titleLable.text = self.movie.original_name ?? self.movie.original_title
        descLabel.text = self.movie.overview
        
    }
    
    @objc private func summaryClicked() {
        let vc = MovieDescriptionViewController()
        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()] /// change to [.medium(), .large()] for a half *and* full screen sheet
        }
        vc.configure(self.movie)
        present(vc, animated: true)
    }
}

extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource, HomeSectionHeaderViewDelegate, CollectionViewTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        var url = ""
        switch indexPath.section {
        case 0:
            url = "\(Constants.baseURL)/3/movie/\(self.movie.id)/recommendations?api_key=\(Constants.APIKEY)"
            
        case 1:
            url = "\(Constants.baseURL)/3/movie/\(self.movie.id)/similar?api_key=\(Constants.APIKEY)"
            
        default:
            return UITableViewCell()
        }
        
        APICaller.shared.getMoviesData(with: url) {results in
            switch results {
            case .success(let movies):
                DispatchQueue.main.async {
                    cell.configure(with: movies)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hView = HomeSectionHeaderView(frame: CGRect(x: 0, y: 0, width: Constants.kWidth, height: 44))
        hView.configure(name: sectionTitles[section], section: section)
        hView.delegate = self
        return hView
    }
    /*
     func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
     guard let header = view as? UITableViewHeaderFooterView else { return }
     
     header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
     header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
     header.textLabel?.textColor = .label
     header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
     }
     
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return sectionTitles[section]
     }*/
    // collectionview delegate
    func didCellClicked(with item: Movie) {
        let vc = MovieDetailsViewController(with: item)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    func didMoreButtonClicked(section: Int) {
        
        switch section {
        case 0:
            let vc = MoviesListViewController(section: 5,movieId: self.movie.id)
            
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            
            let vc = MoviesListViewController(section: 6,movieId: self.movie.id)
            
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("\(section)")
        }
    }
}
