//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 24/05/22.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var viewModels = [MovieViewModel]()
    private var moviesModel = [Movie]()
    let tableView: UITableView = {
        let tablView = UITableView()
        tablView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return tablView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        getUpMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    // get upcoming movies data
    private func getUpMovies() {
        APICaller.shared.getMoviesData(with: Constants.upcomingMovies) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.moviesModel = movies
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
}

// MARK: -Tableview
extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = MovieDetailsViewController(with: self.moviesModel[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
