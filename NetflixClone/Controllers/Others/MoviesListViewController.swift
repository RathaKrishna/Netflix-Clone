//
//  MoviesListViewController.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 06/06/22.
//

import UIKit

 

class MoviesListViewController: UIViewController {

    private var movies: [Movie] = [Movie]()
    private var sectionUrl = ""
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Constants.kWidth/3-8, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeViewCollectionViewCell.self, forCellWithReuseIdentifier: HomeViewCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        return collectionView
    }()
    init(section: Int, movieId: Int) {
        super.init(nibName: nil, bundle: nil)
        switch section {
        case Sections.TrendingMovies.rawValue:
            self.title = "Trending Movies"
            sectionUrl = Constants.trendingMovies
        case Sections.TrendingTv.rawValue:
            title = "Trending TV"
            sectionUrl = Constants.trendingTvs
        case Sections.Popular.rawValue:
            title = "Popular Movies"
            sectionUrl = Constants.popularMovies
        case Sections.Upcoming.rawValue:
            title = "Upcoming Movies"
            sectionUrl = Constants.upcomingMovies
        case Sections.TopRated.rawValue:
            title = "TopRated Movies"
            sectionUrl = Constants.topRatedMovies
        case Sections.Recommended.rawValue:
            title = "Recommended Movies"
            sectionUrl = "\(Constants.baseURL)/3/movie/\(movieId)/recommendations?api_key=\(Constants.APIKEY)"
        case Sections.Similar.rawValue:
            title = "Recommended Movies"
            sectionUrl = "\(Constants.baseURL)/3/movie/\(movieId)/similar?api_key=\(Constants.APIKEY)"
        default:
            title = ""
            sectionUrl = Constants.trendingMovies
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        getData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        
    }
    
    private func getData() {
        APICaller.shared.getMoviesData(with: sectionUrl) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension MoviesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCollectionViewCell.identifier, for: indexPath) as? HomeViewCollectionViewCell else {
            return UICollectionViewCell()
        }
        let poster = movies[indexPath.row]
        cell.configure(with: poster.poster_path ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = MovieDetailsViewController(with: movies[indexPath.row])
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
