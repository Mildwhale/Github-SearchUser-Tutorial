//
//  UserRepository.swift
//  GitHubSearchUser
//
//  Created by Wayne Kim on 30/07/2019.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import Foundation

struct UserRepository {
    var id: Int
    var name: String
    var fullName: String
    var owner: User
    var htmlUrl: URL?
    var createdAt: String?
    var updatedAt: String?
    var pushedAt: String?
    var language: String?
    var stars: Int
    var watchers: Int
    var forks: Int
}

extension UserRepository: Decodable {
    private enum Key: String, CodingKey {
        case id
        case name
        case full_name
        case owner
        case html_url
        case created_at
        case updated_at
        case pushed_at
        case language
        case stargazers_count
        case watchers_count
        case forks_count
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        do {
            id = try container.decode(Int.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            fullName = try container.decode(String.self, forKey: .full_name)
            owner = try container.decode(User.self, forKey: .owner)
            stars = try container.decode(Int.self, forKey: .stargazers_count)
            watchers = try container.decode(Int.self, forKey: .watchers_count)
            forks = try container.decode(Int.self, forKey: .forks_count)
        } catch { throw error }
        
        do {
            htmlUrl = URL(string: try container.decode(String.self, forKey: .html_url))
            createdAt = try container.decode(String.self, forKey: .created_at)
            updatedAt = try container.decode(String.self, forKey: .updated_at)
            pushedAt = try container.decode(String.self, forKey: .pushed_at)
            language = try container.decode(String.self, forKey: .language)
        } catch {}
    }
}
