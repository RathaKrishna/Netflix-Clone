//
//  DownloadViewController.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 24/05/22.
//

import UIKit

class DownloadViewController: UIViewController {
    
    private var viewModels = [MovieViewModel]()
    private var moviesModel = [MovieItem]()
    
    let tableView: UITableView = {
        let tablView = UITableView()
        tablView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return tablView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Download"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        getDownloadMovies()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("MOVIESAVED"), object: nil, queue: nil) { _ in
            self.getDownloadMovies()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // get db saved data
    private func getDownloadMovies() {
        DataPersistanceManager.shared.fetchMoviesFromDB { [weak self ] restul in
            switch restul {
            case .success(let movies):
                self?.moviesModel = movies
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
}
// MARK: - Tableview Delegate
extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }
        let movie = self.moviesModel[indexPath.row]
        
        cell.configure(with:MovieViewModel(imgUrl: "\(Constants.thumbnailImage)\(movie.poster_path ?? "")", title: movie.original_title ?? movie.original_name ?? "", overview: movie.overview ?? "", voteCount: Int(movie.vote_count), releaseDate: movie.release_date ?? "", voteAverage: movie.vote_average))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistanceManager.shared.deleteMovieFromDB(model: self.moviesModel[indexPath.row]) {[weak self] result in
                switch result {
                case .success():
                    print("deleted")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                self?.moviesModel.remove(at: indexPath.row)
            }
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
