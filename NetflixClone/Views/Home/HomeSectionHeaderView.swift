//
//  HomeSectionHeaderView.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 06/06/22.
//

import UIKit

protocol HomeSectionHeaderViewDelegate: AnyObject {
    func didMoreButtonClicked(section: Int)
}

class HomeSectionHeaderView: UIView {

    weak var delegate: HomeSectionHeaderViewDelegate?
    var section = 0
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .label
        return label
    }()
    private let moreBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLbl)
        addSubview(moreBtn)
        moreBtn.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        moreBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    public func configure(name: String, section: Int){
        titleLbl.text = name
        self.section = section
    }

    @objc private func moreButtonClicked() {
        delegate?.didMoreButtonClicked(section: self.section)
    }
}
