//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 24/05/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var viewModels = [MovieViewModel]()
    private var moviesModel = [Movie]()
    
    let tableView: UITableView = {
        let tablView = UITableView()
        tablView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return tablView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
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
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        getUpMovies()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func getUpMovies() {
        APICaller.shared.getMoviesData(with: Constants.trendingMovies) {[weak self] result in
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

// MARK: - Tableview Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil){ _ in
            let downloadAction = UIAction(title: "Download", image: UIImage(systemName: "arrow.down.app.fill"), identifier: nil, discoverabilityTitle: nil,  state: .off) { _ in
                print("download")
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
}
// MARK: - Search delegate
extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating, SearchResultViewControllerDelegate {
    
    // auto search
    func updateSearchResults(for searchController: UISearchController) {
        /*let searchBar = searchController.searchBar
         
         guard let quary = searchBar.text , !quary.trimmingCharacters(in: .whitespaces).isEmpty, quary.trimmingCharacters(in: .whitespaces).count >= 3, let searchResult = searchController.searchResultsController as? SearchResultViewController else { return }
         
         APICaller.shared.searchAll(with: quary) {result in
         DispatchQueue.main.async {
         switch result {
         case .success(let movies):
         searchResult.update(with: movies)
         
         case .failure(let error):
         print(error.localizedDescription)
         }
         }
         
         }*/
    }
    // search when search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchResult = searchController.searchResultsController as? SearchResultViewController,  let searchStr =  searchBar.text, !searchStr.isEmpty else {
            return
        }
        searchResult.delegate = self
        
        APICaller.shared.searchAll(with: searchStr) {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    searchResult.update(with: movies)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    func didSearchResultClicked(_ model: Movie) {
        let vc = MovieDetailsViewController(with: model)
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
