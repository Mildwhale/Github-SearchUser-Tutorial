//
//  HTTPHeaderLinkParser.swift
//  GithubSearchUser-Tutorial
//
//  Created by Wayne Kim on 2019/11/27.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import Foundation

struct HTTPHeaderLink {
    var first: URL?
    var prev: URL?
    var next: URL?
    var last: URL?
}

final class HTTPHeaderLinkParser {
    enum LinkType: String {
        case first = "rel=\"first\""
        case next = "rel=\"next\""
        case prev = "rel=\"prev\""
        case last = "rel=\"last\""
    }
    
    func parseHeader(response: URLResponse?) -> HTTPHeaderLink? {
        return parseHeader(headerFields: (response as? HTTPURLResponse)?.allHeaderFields)
    }
    
    func parseHeader(response: HTTPURLResponse?) -> HTTPHeaderLink? {
        return parseHeader(headerFields: response?.allHeaderFields)
    }
    
    func parseHeader(headerFields: [AnyHashable: Any]?) -> HTTPHeaderLink? {
        return parseHeader(link: headerFields?["Link"] as? String)
    }
    
    func parseHeader(link: String?) -> HTTPHeaderLink? {
        guard let link = link, link.isEmpty == false else {
            return nil
        }
        let links = link.components(separatedBy: ",")
        var headerLink = HTTPHeaderLink()
        links.forEach {
            let components = $0.components(separatedBy:"; ")
            guard let path = components.first, let rel = components.last, path != rel else {
                return
            }
            let cleanPath = path.trimmingCharacters(in: CharacterSet(charactersIn: " <>"))
            if let key = LinkType(rawValue: rel), let url = URL(string: cleanPath) {
                switch key {
                case .first: headerLink.first = url
                case .prev: headerLink.prev = url
                case .next: headerLink.next = url
                case .last: headerLink.last = url
                }
            }
        }
        return headerLink
    }
}
