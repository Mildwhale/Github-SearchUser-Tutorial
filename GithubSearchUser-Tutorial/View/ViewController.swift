//
//  ViewController.swift
//  GithubSearchUser-Tutorial
//
//  Created by Wayne Kim on 2019/11/27.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import UIKit
import SnapKit
import SafariServices

final class ViewController: BaseSearchViewController {
    private let dataManager: ViewControllerDataManager = ViewControllerDataManager()

    override func style() {
        super.style()
        navigationItem.title = "Github Search User"
        
        dataManager.delegate = self
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: ViewControllerDataManagerDelegate {
    func dataSourceChanged() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < dataManager.users.count else {
            return UITableViewCell()
        }
        
        let user = dataManager.users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserTableViewCell", for: indexPath)
        if let searchUserCell = cell as? SearchUserTableViewCell {
            searchUserCell.update(user: user)
            searchUserCell.accessoryType = user.htmlUrl == nil ? .none : .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.users.count
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row < dataManager.users.count else {
            return
        }
        let user = dataManager.users[indexPath.row]
        if let url = user.htmlUrl {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = (dataManager.users.endIndex - 1) == indexPath.row
        if isLastCell && dataManager.paginationAvailable {
            if dataManager.searchNextPage (completionHandler: {
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                }
            }) {
                DispatchQueue.main.async {
                    self.activityIndicatorView.startAnimating()
                }
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if dataManager.search(query: searchText, completionHandler: {
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
            }
        }) {
            DispatchQueue.main.async {
                self.activityIndicatorView.startAnimating()
            }
        }
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

let deviceNames: [String] = [
    "iPhone 11",
]

@available(iOS 13.0, *)
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                UINavigationController(rootViewController: ViewController())
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
