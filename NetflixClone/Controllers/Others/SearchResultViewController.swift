//
//  SearchResultViewController.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 27/05/22.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func didSearchResultClicked(_ model: Movie)
}

class SearchResultViewController: UIViewController {

    private var viewModels = [MovieViewModel]()
    private var moviesModel: [Movie] = [Movie]()
    weak public var delegate: SearchResultViewControllerDelegate?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Constants.kWidth/3 - 6, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    public func update(with models: [Movie]) {
        self.moviesModel = models
        self.viewModels = models.compactMap({
            MovieViewModel(imgUrl: "\(Constants.thumbnailImage)\($0.poster_path ?? "")", title: $0.title ?? "", overview: $0.overview, voteCount: $0.vote_count, releaseDate: $0.release_date ?? "", voteAverage: $0.vote_average)
        })
        collectionView.reloadData()
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: self.viewModels[indexPath.row])
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSearchResultClicked(self.moviesModel[indexPath.row])
    }
    
}
