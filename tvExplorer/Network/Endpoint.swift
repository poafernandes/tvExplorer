//
//  Endpoint.swift
//  tvExplorer
//
//  Created by Alexandre Porto Alegre Fernandes on 12/05/23.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: String { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api.tvmaze.com"
    }
    
    var method: String {
        return "GET"
    }
}
