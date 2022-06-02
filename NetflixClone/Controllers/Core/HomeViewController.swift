//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 24/05/22.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}
class HomeViewController: UIViewController {

    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Moviews", "Top rated"]
    
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    var headerView: HeroHeaderView?
    private var randommovies: [Movie] = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        configureNav()
        headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 400))
        tableView.tableHeaderView = headerView
        getHeaderImg()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateHeader()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = view.bounds
    }

    private func configureNav() {
        var image = UIImage(named: "logo_img")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
    
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(didProfileButtonClicked)),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil),
        ]

        navigationController?.navigationBar.tintColor = .label
    }
    
    @objc private func didProfileButtonClicked() {
        let vc = ProfileViewController()
        vc.navigationItem.largeTitleDisplayMode = .always
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    private func getHeaderImg() {
        APICaller.shared.getMoviesData(with: Constants.trendingMovies) {[weak self]results in
            switch results {
            case .success(let movies):
                DispatchQueue.main.async {
                    self?.randommovies = movies
                    self?.updateHeader()
//                    let num = Int.random(in: 0..<movies.count)
//                    let url = "\(Constants.thumbnailImage)\(movies[num].backdrop_path ?? "")"
//                    self?.headerView?.configureImg(with:url)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateHeader() {
        guard let movie = randommovies.randomElement() else { return }
        self.headerView?.configure(with: movie)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, CollectionViewTableViewCellDelegate {
    
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
        var sectionUrl = ""
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            sectionUrl = Constants.trendingMovies
          
        case Sections.TrendingTv.rawValue:
            sectionUrl = Constants.trendingTvs
        case Sections.Popular.rawValue:
            sectionUrl = Constants.popularMovies
        case Sections.Upcoming.rawValue:
            sectionUrl = Constants.upcomingMovies
        case Sections.TopRated.rawValue:
            sectionUrl = Constants.topRatedMovies
        default:
            sectionUrl = Constants.trendingMovies
        }
        
        APICaller.shared.getMoviesData(with: sectionUrl) {results in
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
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func didCellClicked(with item: Movie) {
        navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
        let vc = MovieDetailsViewController(with: item)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
