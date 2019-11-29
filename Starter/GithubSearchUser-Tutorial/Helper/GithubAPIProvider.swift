//
//  GithubAPIProvider.swift
//  GithubSearchUser-Tutorial
//
//  Created by Wayne Kim on 2019/11/27.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import Foundation
import Moya

enum GithubAPI {
    case searchUser(name: String, page: Int?, perPage: Int?)
}

extension GithubAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .searchUser:
            return "/search/users"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data() // not implemented.
    }
    
    var task: Task {
        switch self {
        case .searchUser(let name, let page, let perPage):
            let encodable = GithubSearchUser.Parameter(query: name, page: page, perPage: perPage)
            guard let dictionary = encodable.dictionary else {
                return .requestPlain
            }
            return .requestParameters(parameters: dictionary, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        /// https://developer.github.com/v3/#rate-limiting
        var clientId: String? {
            if let id = Bundle.main.object(forInfoDictionaryKey: "GITHUB_CLIENT_ID") as? String, id.isEmpty == false {
                return id
            }
            return nil
        }
        var clientSecret: String? {
            if let secret = Bundle.main.object(forInfoDictionaryKey: "GITHUB_CLIENT_SECRET") as? String, secret.isEmpty == false {
                return secret
            }
            return nil
        }
        
        guard let id = clientId, let secret = clientSecret else { return nil }
        return ["client_id": id,
                "client_secret": secret]
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
