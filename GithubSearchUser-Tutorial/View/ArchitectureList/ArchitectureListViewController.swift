//
//  ArchitectureListViewController.swift
//  GithubSearchUser-Tutorial
//
//  Created by Wayne Kim on 2020/05/09.
//  Copyright © 2020 Wayne Kim. All rights reserved.
//

import UIKit
import SnapKit

enum SupportedArchitecture: String, CaseIterable {
    case mvc
    case mvvm
}

final class ArchitectureListViewController: BaseViewController {
    private let tableView: UITableView = UITableView()
    private let loginButton: UIBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(login(_:)))
    
    override func addSubview() {
        view.addSubview(tableView)
    }
    
    override func layout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func style() {
        navigationItem.title = "Choose Architecture"
        navigationItem.rightBarButtonItem = loginButton
        
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func login(_ sender: UIBarButtonItem) {
        print(#function)
    }
}

extension ArchitectureListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SupportedArchitecture.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "ArchitectureCell"
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        cell?.textLabel?.text = SupportedArchitecture.allCases[indexPath.row].rawValue.uppercased()
        return cell
    }
}

extension ArchitectureListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
