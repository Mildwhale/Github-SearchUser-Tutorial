//
//  GithubAPIProvider.swift
//  GithubSearchUser-Tutorial
//
//  Created by Wayne Kim on 2019/11/27.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import Foundation

struct GitHubAppKey {
    static var clientId: String? {
        if let id = Bundle.main.object(forInfoDictionaryKey: "GITHUB_CLIENT_ID") as? String, id.isEmpty == false {
            return id
        }
        return nil
    }
    static var secret: String? {
        if let secret = Bundle.main.object(forInfoDictionaryKey: "GITHUB_CLIENT_SECRET") as? String, secret.isEmpty == false {
            return secret
        }
        return nil
    }
    static let host = "api.github.com"
}

struct GitHubApi {
    static var searchUsers: String {
        return "https://api.github.com/search/users"
    }
    
    static func repositories(userName: String) -> String {
        return "https://api.github.com/users/\(userName)/repos"
    }
}
