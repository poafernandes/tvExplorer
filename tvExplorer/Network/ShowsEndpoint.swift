//
//  ShowsEndpoint.swift
//  tvExplorer
//
//  Created by Alexandre Porto Alegre Fernandes on 12/05/23.
//

import Foundation

enum ShowsEndpoint {
    case searchShows(page: String)
    case searchShow(query: String)
    case searchAliases(id: String)
}

extension ShowsEndpoint: Endpoint {
    var header: [String : String]? {
        switch self {
        case .searchShows, .searchShow, .searchAliases:
            return [
                "Content-Type": "application/json; charset=utf-8"
            ]
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .searchShow, .searchShows, .searchAliases:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .searchShows:
            return "/shows"
        case .searchShow:
            return "/search/shows"
        case .searchAliases(let id):
            return "/shows/\(id)/akas"
        }
        
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .searchShow(let query):
            return [URLQueryItem(name: "q", value: query)]
        case .searchShows(let page):
            return [URLQueryItem(name: "page", value: page)]
        case.searchAliases:
            return []
        }
    }
}
