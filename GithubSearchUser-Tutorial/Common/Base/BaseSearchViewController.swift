//
//  BaseSearchViewController.swift
//  GithubSearchUser-Tutorial
//
//  Created by Wayne Kim on 2020/05/07.
//  Copyright © 2020 Wayne Kim. All rights reserved.
//

import UIKit
import SnapKit

open class BaseSearchViewController: BaseViewController {
    private let loginButton: UIButton = UIButton(type: .system)
    public let rootStackView: UIStackView = UIStackView()
    public let searchBar: UISearchBar = UISearchBar()
    public let tableView: UITableView = UITableView()
    public let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    open override func addSubview() {
        super.addSubview()
        view.addSubview(rootStackView)
        view.addSubview(activityIndicatorView)
        
        rootStackView.addArrangedSubview(searchBar)
        rootStackView.addArrangedSubview(tableView)
        
        let buttonItem = UIBarButtonItem(customView: loginButton)
        navigationItem.rightBarButtonItem = buttonItem
    }
    
    open override func layout() {
        super.layout()
        rootStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    open override func style() {
        super.style()
        view.backgroundColor = .white
        
        rootStackView.axis = .vertical
        rootStackView.alignment = .fill
        
        loginButton.setTitle("로그인", for: .normal)
        loginButton.setTitleColor(.systemBlue, for: .normal)
        
        activityIndicatorView.hidesWhenStopped = true
        
        tableView.register(SearchUserTableViewCell.self, forCellReuseIdentifier: "SearchUserTableViewCell")
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    open override func behavior() {
        super.behavior()
        loginButton.addTarget(self, action: #selector(presentLoginVC(_:)), for: .touchUpInside)
    }
    
    @objc private func presentLoginVC(_ sender: UIButton) {
        let vc = LoginViewController()
        present(vc, animated: true, completion: nil)
    }
}

import WebKit

final class LoginViewController: UIViewController {
    private let webview: WKWebView = WKWebView()
    private let baseUrl: String = "https://github.com/login/oauth/authorize"
    private let client_id: String = "935c942a53dee7a13ced"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view = webview
        
        var components = URLComponents(string: baseUrl)
        let queryItem = URLQueryItem(name: "client_id", value: client_id)
        components?.queryItems = [queryItem]
        
        if let url = components?.url {
            let request = URLRequest(url: url)
            webview.load(request)
        }
    }
}
