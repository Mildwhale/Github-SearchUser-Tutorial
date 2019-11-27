//
//  ViewControllerDataManager.swift
//  GithubSearchUser-Tutorial
//
//  Created by Wayne Kim on 2019/11/27.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import Foundation
import Alamofire

protocol ViewControllerDataManagerDelegate: AnyObject {
    func dataSourceChanged()
}

final class ViewControllerDataManager {
    // MARK: - Value
    // MARK: Public
    var paginationAvailable: Bool {
        return latestSearchLink?.next != nil
    }
    
    private(set) var users: [User] = [] {
        didSet {
            delegate?.dataSourceChanged()
        }
    }
    
    weak var delegate: ViewControllerDataManagerDelegate?
    
    // MARK: Private
    private var isInprogressPagination = false
    
    private var latestQuery = ""
    private var latestSearchLink: HTTPHeaderLink?
    
    private let debouncer = Debouncer(interval: 0.3)
    
    // MARK: - Function
    // MARK: Public
    func search(query: String, completionHandler: @escaping () -> Void) -> Bool {
        if latestQuery != query {
            resetCachedParameters()
            users.removeAll()
        }
        latestQuery = query
        
        guard query.isEmpty == false, let url = URL(string: GitHubApi.searchUsers) else {
            completionHandler()
            return false
        }
        
        debouncer.call {
            let parameter = SearchUserParameter(query: query, page: 1, perPage: 20)
            AF.request(url, parameters: parameter).responseData { [weak self] response in
                guard self?.latestQuery == parameter.query else {
                    print("Search result skipped (keyword: \'\(parameter.query)\').")
                    return
                }
                self?.handleSearchResult(response: response, completionHandler: completionHandler)
            }
        }
        return true
    }
    
    func searchNextPage(completionHandler: @escaping () -> Void) -> Bool {
        guard isInprogressPagination == false, let nextUrl = latestSearchLink?.next else {
            return false
        }
        
        AF.request(nextUrl).responseData { [weak self] response in
            let paginationQuery = Utility.extractQuery(from: response.response?.url)
            guard self?.latestQuery == paginationQuery else {
                print("Search result skipped (keyword: \'\(paginationQuery ?? "")\').")
                return
            }
            self?.handleSearchResult(response: response, completionHandler: {
                self?.isInprogressPagination = false
                completionHandler()
            })
        }
        
        isInprogressPagination = true
        return true
    }
    
    // MARK: Private
    private func handleSearchResult(response: AFDataResponse<Data>, completionHandler: @escaping () -> Void) {
        guard let users = decodeSearchUserResponse(response: response) else {
            print(response.error.debugDescription)
            completionHandler()
            return
        }
        extractHTTPHeaderLink(response: response)
        updateUsers(items: users.items)

        completionHandler()
        
        // DEBUG Print
        let currentPage = Utility.extractPage(from: response.response?.url) ?? -1
        let nextPage = Utility.extractPage(from: latestSearchLink?.next) ?? -1
        let lastPage = Utility.extractPage(from: latestSearchLink?.last) ?? -1
        let message = "SearchUser current: \(currentPage), next: \(nextPage), last: \(lastPage)"
        print(message)
    }
    
    private func decodeSearchUserResponse(response: AFDataResponse<Data>) -> SearchUserResponse? {
        guard response.error == nil, let decodableData = response.data else {
            return nil
        }
        do {
            return try JSONDecoder().decode(SearchUserResponse.self, from: decodableData)
        } catch {
            return nil
        }
    }
    
    private func extractHTTPHeaderLink(response: AFDataResponse<Data>) {
        latestSearchLink = HTTPHeaderLinkParser().parseHeader(response: response.response)
    }
    
    private func updateUsers(items: [User]) {
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
