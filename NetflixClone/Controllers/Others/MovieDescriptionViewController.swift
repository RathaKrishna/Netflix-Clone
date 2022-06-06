//
//  MovieDescriptionViewController.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 06/06/22.
//

import UIKit

class MovieDescriptionViewController: UIViewController {
    
    
    private let dateLable: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    private let rateLable: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    private let descLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(dateLable)
        view.addSubview(rateLable)
        view.addSubview(descLable)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        dateLable.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(10)
        }
        rateLable.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-10)
        }
        descLable.snp.makeConstraints { make in
            make.top.equalTo(dateLable.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        
    }
    
    public func configure(_ model: Movie){
        dateLable.text = "Released On: \(model.release_date ?? model.first_air_date ?? "")"
        rateLable.text = "IMDB: ⭐️ \(model.vote_average)/10"
        descLable.text = "\nOverivew:\n\n\(model.overview)"
        
    }
}
