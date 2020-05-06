//
//  SearchUserTableViewCell.swift
//  GitHubSearchUser
//
//  Created by Wayne Kim on 29/07/2019.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import UIKit
import SDWebImage

final class SearchUserTableViewCell: UITableViewCell {
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var reposCountLabel: UILabel!
    
    private var observer: NSKeyValueObservation?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        observer?.invalidate()
        observer = nil
    }
    
    func update(viewModel: SearchUserCellViewModel) {
        avatarImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
        nameLabel.text = viewModel.userNameText
        reposCountLabel.text = viewModel.repositoriesText
        
        addRepositoriesObserver(viewModel: viewModel)
    }
    
    private func addRepositoriesObserver(viewModel: SearchUserCellViewModel) {
        if observer == nil {
            observer = viewModel.observe(\.countOfRepositories, changeHandler: { [weak self] (model, _) in
                DispatchQueue.main.async {
                    self?.reposCountLabel.text = model.repositoriesText
                }
            })
        }
    }
}
