//
//  Utility.swift
//  GithubSearchUser-Tutorial
//
//  Created by Wayne Kim on 2019/11/27.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import Foundation

final class Utility {
    static func extractPage(from url: URL?) -> Int? {
        guard let urlString = url?.absoluteString, let components = URLComponents(string: urlString), let queryItems = components.queryItems else {
            return nil
        }
        if let pageString = queryItems.filter({ $0.name == "page" }).first?.value, let page = Int(pageString) {
            return page
        }
        return nil
    }
    
    static func extractQuery(from url: URL?) -> String? {
        guard let urlString = url?.absoluteString, let components = URLComponents(string: urlString), let queryItems = components.queryItems else {
            return nil
        }
        if let queryString = queryItems.filter({ $0.name == "q" }).first?.value {
            return queryString
        }
        return nil
    }
    
    /// https://developer.github.com/v3/#rate-limiting
    static func appendGitHubClientSecret(url: URL?) -> URL? {
        guard let url = url, let clientId = GitHubAppKey.clientId, let secret = GitHubAppKey.secret else {
            return nil
        }
        
        if let components = URLComponents(string: url.absoluteString), components.host == GitHubAppKey.host {
            var newUrlString = url.absoluteString
            if let queryItems = components.queryItems {
                guard queryItems.filter({ $0.name == "client_id" || $0.name == "client_secret" }).isEmpty else {
                    return url
                }
                newUrlString.append("&")
            } else {
                newUrlString.append("?")
            }
            newUrlString.append("client_id=\(clientId)&client_secret=\(secret)")
            return URL(string: newUrlString)
        } else {
            return url
        }
    }
}
