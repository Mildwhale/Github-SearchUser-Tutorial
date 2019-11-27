//
//  SearchUserResponse.swift
//  GithubSearchUser
//
//  Created by Wayne Kim on 29/07/2019.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import Foundation

struct SearchUserResponse {
    var totalCount: Int
    var incompleteResults: Bool
    var items: [User]
}

extension SearchUserResponse: Decodable {
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
            items = try container.decode([User].self, forKey: .items)
        } catch { throw error }
    }
}

struct User {
    var name: String
    var id: Int
    var nodeId: String
    var avartarUrl: URL?
    var gravartarId: String
    var url: URL?
    var htmlUrl: URL?
    var followersUrl: URL?
    var subscriptionsUrl: URL?
    var organiztionsUrl: URL?
    var repositoriesUrl: URL?
    var receivedEventsUrl: URL?
    var type: String?
    var score: Double
}

extension User: Decodable {
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
