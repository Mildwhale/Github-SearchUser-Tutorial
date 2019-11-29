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
}

extension Encodable {
    var dictionary: [String: Any]? {
        do {
            let encodedData = try JSONEncoder().encode(self)
            if let dictionary = try JSONSerialization.jsonObject(with: encodedData, options: []) as? [String: Any] {
                return dictionary
            }
        }
        catch {
        }
        return nil
    }
}
