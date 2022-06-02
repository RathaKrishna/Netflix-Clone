//
//  HeroHeaderView.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 24/05/22.
//

import UIKit
import SDWebImage
import SnapKit

class HeroHeaderView: UIView {
    
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        clipsToBounds = true
        addSubview(imageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        //        applyConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        playButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(55)
            make.bottom.equalToSuperview().offset(-55)
            make.width.greaterThanOrEqualTo(120)
            make.height.equalTo(44)
        }
        downloadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-55)
            make.bottom.equalToSuperview().offset(-55)
            make.width.greaterThanOrEqualTo(120)
            make.height.equalTo(44)
        }
        
    }
    public func configure(with model: Movie){
        let url = "\(Constants.thumbnailImage)\(model.backdrop_path ?? "")"
        imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: "photo"))
    }
    
    // Demo for Auto layout without snapkit tool
    //    private func applyConstraints() {
    //        let playButtonConstraints = [
    //            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 55),
    //            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
    //            playButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
    //        ]
    //
    //        let downloadButtonConstraints = [
    //            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -55),
    //            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
    //            downloadButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
    //        ]
    //
    //        NSLayoutConstraint.activate(playButtonConstraints)
    //        NSLayoutConstraint.activate(downloadButtonConstraints)
    //    }
}
