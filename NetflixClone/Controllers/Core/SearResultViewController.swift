//
//  SearResultViewController.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 27/05/22.
//

import UIKit

class SearResultViewController: UIViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
    }
    


}
