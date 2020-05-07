//
//  GithubSearchViewModel.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/05/07.
//  Copyright © 2020 hmhv. All rights reserved.
//

import Foundation
import MobS

class GithubSearchViewModel {

    @MobS.Observable(value: [])
    private(set) var repos: [GithubRepo]

    @MobS.Observable(value: false)
    private(set) var isLoading: Bool

    @MobS.Observable(value: nil)
    private(set) var error: Error?

    private let searchService = GithubSearchService()
    private var searchParameter = GithubSearchParameter.emptyParameter

    func search(query: String) {
        repos = []
        if query.isEmpty {
            searchParameter = GithubSearchParameter.emptyParameter
        } else {
            searchParameter = GithubSearchParameter(query: query)
            search()
        }
    }

    func searchMore() {
        guard !isLoading else { return }

        if !searchParameter.isSearchFinished {
            searchParameter.page += 1
            search()
        }
    }

    private func search() {
        isLoading = true
        searchService.search(searchParameter: searchParameter) { [weak self] parameter, response, error in
            guard let self = self else { return }
            if self.searchParameter.query == parameter.query {
                MobS.updateState {
                    self.isLoading = false
                    if let error = error {
                        self.error = error
                        self.searchParameter.isSearchFinished = true
                    } else if let response = response {
                        if response.items.count > 0 {
                            self.repos.append(contentsOf: response.items)
                        }
                        if response.totalCount == self.repos.count {
                            self.searchParameter.isSearchFinished = true
                        }
                    }
                }
            }
        }
    }
    
}
