//
//  SearchUserTableViewCell.swift
//  GithubSearchUser-Tutorial
//
//  Created by Wayne Kim on 2019/11/27.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import UIKit
import Kingfisher

final class SearchUserTableViewCell: UITableViewCell {
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    private func layout() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        
        avatarImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8.0)
            $0.leading.equalToSuperview().offset(15.0)
            $0.bottom.equalToSuperview().inset(8.0)
            $0.width.equalTo(50.0)
            $0.height.equalTo(50.0).priority(.high)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(8.0)
            $0.trailing.equalToSuperview().inset(8.0)
            $0.centerY.equalToSuperview()
        }
    }
    
    func update(user: User) {
        avatarImageView.kf.setImage(with: user.avartarUrl)
        nameLabel.text = user.name
    }
}
