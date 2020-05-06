//
//  ViewControllerDataManager.swift
//  GithubSearchUser-Tutorial
//
//  Created by Wayne Kim on 2019/11/27.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import Foundation
import Moya

protocol ViewControllerDataManagerDelegate: AnyObject {
    func dataSourceChanged()
}

final class ViewControllerDataManager {
    // MARK: - Value
    // MARK: Public
    var paginationAvailable: Bool {
        return latestSearchLink?.next != nil
    }
    
    private(set) var users: [GithubSearchUser.User] = [] {
        didSet {
            delegate?.dataSourceChanged()
        }
    }
    
    weak var delegate: ViewControllerDataManagerDelegate?
    
    // MARK: Private
    private let provider = MoyaProvider<GithubAPI>()
    private var isInprogressPagination = false
    
    private var latestQuery = ""
    private var latestSearchLink: HTTPHeaderLink?
    private var cancellable: Cancellable?
    
    private let debouncer = Debouncer(interval: 0.3)
    
    // MARK: - Function
    // MARK: Public
    func search(query: String, completionHandler: @escaping () -> Void) -> Bool {
        cancel()
        
        if latestQuery != query {
            resetCachedParameters()
            users.removeAll()
        }
        latestQuery = query
        
        guard query.isEmpty == false else {
            completionHandler()
            return false
        }
        
        debouncer.call { [weak self] in
            guard let self = self else { return }
            self.cancellable = self.provider.request(.searchUser(name: query, page: 1, perPage: 20)) { result in
                let handler: () -> Void = { [weak self] in
                    self?.cancellable = nil
                    completionHandler()
                }
                
                switch result {
                case let .success(response):
                    self.handleSearchResult(response: response, completionHandler: handler)
                case let .failure(error):
                    self.handleSearchFailure(error: error, completionHandler: handler)
                }
            }
        }
        return true
    }
    
    func searchNextPage(completionHandler: @escaping () -> Void) -> Bool {
        guard
            isInprogressPagination == false,
            let nextUrl = latestSearchLink?.next,
            let query = Utility.extractQuery(from: nextUrl),
            let nextPage = Utility.extractPage(from: nextUrl) else {
            return false
        }
        
        cancellable = provider.request(.searchUser(name: query, page: nextPage, perPage: 20)) { result in
            let handler: () -> Void = { [weak self] in
                self?.isInprogressPagination = false
                self?.cancellable = nil
                completionHandler()
            }
            
            switch result {
            case let .success(response):
                self.handleSearchResult(response: response, completionHandler: handler)
            case let .failure(error):
                self.handleSearchFailure(error: error, completionHandler: handler)
            }
        }
        
        isInprogressPagination = true
        return true
    }
    
    // MARK: Private
    private func cancel() {
        if let latestRequest = cancellable, latestRequest.isCancelled == false {
            print("Latest request will be cancelled. (keyword: \(latestQuery))")
            latestRequest.cancel()
            cancellable = nil
        }
    }
    
    private func handleSearchResult(response: Moya.Response, completionHandler: @escaping () -> Void) {
        print(response.description)
        
        defer { completionHandler() }
        guard let users = decodeSearchUserResponse(response: response) else { return }
        extractHTTPHeaderLink(response: response)
        updateUsers(items: users.items)
    }
    
    private func handleSearchFailure(error: Moya.MoyaError, completionHandler: @escaping () -> Void) {
        print(error.localizedDescription)
        completionHandler()
    }
    
    private func decodeSearchUserResponse(response: Moya.Response) -> GithubSearchUser.Response? {
        do {
            return try JSONDecoder().decode(GithubSearchUser.Response.self, from: response.data)
        } catch {
            return nil
        }
    }
    
    private func extractHTTPHeaderLink(response: Moya.Response) {
        latestSearchLink = HTTPHeaderLinkParser().parseHeader(response: response.response)
    }
    
    private func updateUsers(items: [GithubSearchUser.User]) {
        if isInprogressPagination {
            users.append(contentsOf: items)
        } else {
            users = items
        }
    }
    
    private func resetCachedParameters() {
        latestQuery = ""
        latestSearchLink = nil
    }
}
