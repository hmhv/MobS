//
//  GithubSearchService.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/05/07.
//  Copyright © 2020 hmhv. All rights reserved.
//

import Foundation

enum GithubSearchError: Error {
    case error403
    case invalidResponse
}

class GithubSearchService {

    func search(searchParameter: GithubSearchParameter, completionHandler: @escaping (GithubSearchParameter, GithubSearchResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: searchParameter.request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                if response.statusCode >= 200, response.statusCode < 300, let data = data {
                    do {
                        let decoded = try GithubSearchService.decoder.decode(GithubSearchResponse.self, from: data)
                        completionHandler(searchParameter, decoded, nil)
                        return
                    } catch {
                        debugPrint("\(error)")
                    }
                } else if response.statusCode == 403 {
                    completionHandler(searchParameter, nil, GithubSearchError.error403)
                    return
                }
            }
            completionHandler(searchParameter, nil, error ?? GithubSearchError.invalidResponse)
        }
        task.resume()
    }

    static private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

}


struct GithubSearchResponse: Decodable {
    let totalCount: Int
    let items: [GithubRepo]
}

struct GithubRepo: Decodable {
    let id: Int
    let name: String?
    let fullName: String?
    let description: String?
    let language: String?
}

struct GithubSearchParameter {

    static let emptyParameter = GithubSearchParameter(query: "", isSearchFinished: true)

    let query: String
    var page = 1
    var isSearchFinished = false

    var request: URLRequest {
        let url = URL(string: "https://api.github.com/search/repositories?q=\(query)&per_page=20&page=\(page)")!
        var request = URLRequest(url: url)
        //request.addValue("token your_token_here", forHTTPHeaderField: "Authorization")
        return request
    }
    
}

