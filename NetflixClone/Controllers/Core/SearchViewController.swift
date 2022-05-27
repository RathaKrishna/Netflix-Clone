//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 24/05/22.
//

import UIKit

class SearchViewController: UIViewController {

    private var viewModels = [SearchViewModel]()

    
    let tableView: UITableView = {
        let tablView = UITableView()
        tablView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return tablView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearResultViewController())
        controller.searchBar.placeholder = "Search Movie,TV show..."
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        navigationItem.searchController = searchController
        
        getUpMovies()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func getUpMovies() {
        APICaller.shared.searchAll(with: "\(Constants.searchAll)") {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.viewModels = movies.compactMap({
                        SearchViewModel(imgUrl: "\(Constants.thumbnailImage)\($0.poster_path ?? "")", title: $0.title ?? $0.name ?? "", overview: $0.overview ?? "", type: $0.media_type ?? "")
                    })
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    private func discoverMovies(){
        APICaller.shared.searchAll(with: "\(Constants.searchAll)hacks") {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.viewModels = movies.compactMap({
                        SearchViewModel(imgUrl: "\(Constants.thumbnailImage)\($0.poster_path ?? "")", title: $0.title ?? $0.name ?? "", overview: $0.overview ?? "", type: $0.media_type ?? "")
                    })
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension SearchViewController: UISearchControllerDelegate {
    
}
