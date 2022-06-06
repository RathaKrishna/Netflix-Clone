//
//  HomeViewCollectionViewCell.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 26/05/22.
//

import UIKit

class HomeViewCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeViewCollectionViewCell"
    
    private let posterImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 12
        imgView.layer.masksToBounds = true
        imgView.clipsToBounds = true
        return imgView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        contentView.addSubview(posterImgView)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImgView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImgView.frame = contentView.bounds
    }
    
    public func configure(with name: String) {
        
        let url = URL(string: Constants.thumbnailImage + name)
        self.posterImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "home_header_img"))
        
        
    }
}
