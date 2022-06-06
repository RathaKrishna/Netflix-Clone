//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 24/05/22.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func didCellClicked(with item: Movie);
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var movies: [Movie] = [Movie]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeViewCollectionViewCell.self, forCellWithReuseIdentifier: HomeViewCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect(x: 5, y: 0, width: contentView.bounds.width-10, height: contentView.bounds.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movies = [Movie]()
    }
    public func configure(with models: [Movie]) {
        self.movies = models
        self.collectionView.reloadData()
        
    }
    
    private func downloadMovieAt(indexPath: IndexPath) {
        //        MovieItem.
        DataPersistanceManager.shared.downloadMovieWith(model: self.movies[indexPath.row]) { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    print("data saved")
                    NotificationCenter.default.post(name: NSNotification.Name("MOVIESAVED"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

extension CollectionViewTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        let movie = movies[indexPath.row]
        self.delegate?.didCellClicked(with: movie)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil){ _ in
            let downloadAction = UIAction(title: "Download", image: UIImage(systemName: "arrow.down.app.fill"), identifier: nil, discoverabilityTitle: "Discover", state: .off) { _ in
                self.downloadMovieAt(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            
        }
        return config
    }
    
}
