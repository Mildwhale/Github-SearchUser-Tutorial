//
//  GithubSearchUser.swift
//  GithubSearchUser
//
//  Created by Wayne Kim on 29/07/2019.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import Foundation

struct GithubSearchUser {
    struct Parameter {
        enum Sort: String {
            case `default`
            case followers
            case repositories
            case joined
        }
        
        enum Order: String {
            case desc
            case asc
        }
        
        let query: String
        let sort: Sort?
        let order: Order?
        let page: Int?
        let perPage: Int?
        
        init(query: String, sort: Sort? = nil, order: Order? = nil, page: Int? = nil, perPage: Int? = nil) {
            self.query = query
            self.sort = sort
            self.order = order
            self.page = page
            self.perPage = perPage
        }
    }
    
    struct Response {
        let totalCount: Int
        let incompleteResults: Bool
        let items: [User]
    }
    
    struct User {
        let name: String
        let id: Int
        let nodeId: String
        let avartarUrl: URL?
        let gravartarId: String
        let url: URL?
        let htmlUrl: URL?
        let followersUrl: URL?
        let subscriptionsUrl: URL?
        let organiztionsUrl: URL?
        let repositoriesUrl: URL?
        let receivedEventsUrl: URL?
        let type: String?
        let score: Double
    }
}

extension GithubSearchUser.Parameter: Encodable {
    private enum Key: String, CodingKey {
        case q
        case sort
        case order
        case page
        case per_page
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do {
            if let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                try container.encode(encodedQuery, forKey: .q)
            }
            if let sort = sort, sort != .default {
                try container.encode(sort.rawValue, forKey: .sort)
            }
            if let order = order {
                try container.encode(order.rawValue, forKey: .order)
            }
            if let page = page, let perPage = perPage {
                try container.encode(page, forKey: .page)
                try container.encode(perPage, forKey: .per_page)
            }
        } catch { throw error }
    }
}

extension GithubSearchUser.Response: Decodable {
    private enum Key: String, CodingKey {
        case total_count
        case incomplete_results
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do {
            totalCount = try container.decode(Int.self, forKey: .total_count)
            incompleteResults = try container.decode(Bool.self, forKey: .incomplete_results)
            items = try container.decode([GithubSearchUser.User].self, forKey: .items)
        } catch { throw error }
    }
}

extension GithubSearchUser.User: Decodable {
    private enum Key: String, CodingKey {
        case login
        case id
        case node_id
        case avatar_url
        case gravatar_id
        case url
        case html_url
        case followers_url
        case subscriptions_url
        case organizations_url
        case repos_url
        case received_events_url
        case type
        case score
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        do {
            name = try container.decode(String.self, forKey: .login)
            id = try container.decode(Int.self, forKey: .id)
            nodeId = try container.decode(String.self, forKey: .node_id)
            avartarUrl = URL(string: try container.decode(String.self, forKey: .avatar_url))
            gravartarId = try container.decode(String.self, forKey: .gravatar_id)
            url = URL(string: try container.decode(String.self, forKey: .url))
            htmlUrl = URL(string: try container.decode(String.self, forKey: .html_url))
            followersUrl = URL(string: try container.decode(String.self, forKey: .followers_url))
            subscriptionsUrl = URL(string: try container.decode(String.self, forKey: .subscriptions_url))
            organiztionsUrl = URL(string: try container.decode(String.self, forKey: .organizations_url))
            repositoriesUrl = URL(string: try container.decode(String.self, forKey: .repos_url))
            receivedEventsUrl = URL(string: try container.decode(String.self, forKey: .received_events_url))
            type = try container.decode(String.self, forKey: .type)
        } catch { throw error }
        do {
            score = try container.decode(Double.self, forKey: .score)
        } catch { score = 0 }
    }
}
