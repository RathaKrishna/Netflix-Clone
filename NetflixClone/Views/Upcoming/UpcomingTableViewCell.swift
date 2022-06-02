//
//  UpcomingTableViewCell.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 26/05/22.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {
    static let identifier = "UpcomingTableViewCell"
    
    private let albumImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let titleLabel: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 18, weight: .semibold)
        lable.textColor = .label
        lable.numberOfLines = 1
        return lable
    }()
    
    private let descLabel: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 14, weight: .regular)
        lable.textColor = .secondaryLabel
        lable.numberOfLines = 3
        return lable
    }()
    
    private let dateLabel: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 12, weight: .light)
        lable.textColor = .secondaryLabel
        lable.numberOfLines = 1
        lable.textAlignment = .right
        return lable
    }()
    
    private let ratingLabel: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 12, weight: .light)
        lable.textColor = .secondaryLabel
        lable.numberOfLines = 1
        return lable
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        button.clipsToBounds = true
        button.tintColor = .label
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(albumImgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(playButton)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImgView.image = nil
        titleLabel.text = nil
        descLabel.text = nil
        dateLabel.text = nil
        ratingLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumImgView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(5)
            make.width.equalTo(80)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumImgView.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(descLabel.snp.bottom).offset(2)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(ratingLabel)
            make.trailing.equalTo(titleLabel)
        }
        
        playButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.center.equalTo(albumImgView)
        }
    }
    
    public func configure(with model: MovieViewModel) {
        
        albumImgView.sd_setImage(with: URL(string: model.imgUrl), placeholderImage: UIImage(named: "home_header_img"))
        titleLabel.text = model.title
        descLabel.text = model.overview
        ratingLabel.text = "Rating: \(model.voteAverage)%"
        dateLabel.text = "Released on: \(model.releaseDate)"
    }
}
