//
//  SearchUserParameter.swift
//  GithubSearchUser
//
//  Created by Wayne Kim on 29/07/2019.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import Foundation

struct SearchUserParameter {
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
    
    var query: String
    var sort: Sort?
    var order: Order?
    var page: Int?
    var perPage: Int?
    
    init(query: String, sort: Sort? = nil, order: Order? = nil, page: Int? = nil, perPage: Int? = nil) {
        self.query = query
        self.sort = sort
        self.order = order
        self.page = page
        self.perPage = perPage
    }
}

extension SearchUserParameter: Encodable {
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
