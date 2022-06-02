//
//  SearchResultCollectionViewCell.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 31/05/22.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchResultCollectionViewCell"
    
    private let posterImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    private let starImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
//        let imgae = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40) )
        imgView.image = UIImage(systemName: "star.fill")
        imgView.tintColor = .yellow
        return imgView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(posterImgView)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(starImgView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImgView.image = nil
        ratingLabel.text = nil
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImgView.frame = contentView.bounds
        
        ratingLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-6)
            make.top.equalToSuperview().offset(6)
        }
        
        starImgView.snp.makeConstraints { make in
            make.right.equalTo(ratingLabel.snp.left).offset(-2)
            make.width.height.equalTo(22)
            make.centerY.equalTo(ratingLabel)
        }
    }
    
    public func configure(with model: MovieViewModel) {
        
        let url = URL(string: model.imgUrl)
        self.posterImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "home_header_img"))
        ratingLabel.text = "\(model.voteAverage)"
    }
}
