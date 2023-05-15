//
//  MockNetworkService.swift
//  tvExplorerTests
//
//  Created by Alexandre Porto Alegre Fernandes on 15/05/23.
//

import Foundation
@testable import tvExplorer

final class MockNetworkService: Mockable, ShowsNetworkServiceable {
    func searchShowQuery(query: String) async throws -> tvExplorer.JsonShowsResponse {
        let json = loadJSON(filename: "search", type: JsonSearchResponse.self)
        return json.map { result in
            return result.show!
        }
    }
    
    func searchShowAliases(id: String) async throws -> [String] {
        let json = loadJSON(filename: "aliases", type: JsonAliases.self)
        return json.compactMap{ $0.name }

    }
    
    func searchShows(page: Int) async throws -> JsonShowsResponse {
        let json = loadJSON(filename: "shows", type: JsonShowsResponse.self)
        return json
    }
    
}
