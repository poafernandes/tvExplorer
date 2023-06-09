//
//  ShowsNetworkService.swift
//  tvExplorer
//
//  Created by Alexandre Porto Alegre Fernandes on 12/05/23.
//

import Foundation
import UIKit


protocol ShowsNetworkServiceable: NetworkClient {
    func searchShows(page: Int) async throws -> JsonShowsResponse
    func searchShowQuery(query: String) async throws -> JsonShowsResponse
    func searchShowAliases(id: String) async throws -> [String]
}

enum TestError: Error {
    case fileNotFound
    case decodingFailed
}

actor ShowsNetworkService: NetworkClient, ShowsNetworkServiceable {
    
    private var activeRequests = [String?: Task<JsonShowsResponse,Error>]()
    
    func searchShows(page: Int) async throws -> JsonShowsResponse {
        
        if let requestExists = activeRequests[String(page)] {
            return try await requestExists.value
        }
        
        let request = Task<JsonShowsResponse, Error> {
            do {
                #if DEBUG
                    print("Searching shows without query")
                #endif
                let result = try await requestFromEndpoint(endpoint: ShowsEndpoint.searchShows(page: String(page)), responseModel: JsonShowsResponse.self)
    //            let result = try await requestFromBundleFile(filename: "shows", responseModel: JsonShowsResponse.self)
                
                switch result {
                case .success(let showsResponse):
                    activeRequests[String(page)] = nil
                    return showsResponse
                case .failure(let error):
                    #if DEBUG
                        print(error)
                    #endif
                    throw NetworkError.invalidContent
                }
            } catch {
                #if DEBUG
                    print(error)
                #endif
                throw NetworkError.unexpectedStatusCode
            }
        }
        
        activeRequests[String(page)] = request
        
        return try await request.value
    }
    
    func searchShowQuery(query: String) async throws -> JsonShowsResponse {
        
        if let requestExists = activeRequests[query] {
            return try await requestExists.value
        }
        
        let request = Task<JsonShowsResponse, Error>{
            do {
                #if DEBUG
                    print("Searching shows with query \(query)")
                #endif
                
                let result = try await requestFromEndpoint(endpoint: ShowsEndpoint.searchShow(query: query), responseModel: JsonSearchResponse.self)
                //            let result = try await requestFromBundleFile(filename: "search", responseModel: JsonSearchResponse.self)
                
                switch result {
                case .success(let showsResponse):
                    
                    let resultArray: [JsonShow?] = await showsResponse.asyncMap { result in
                        return result.show
                    }
                    
                    activeRequests[query] = nil
                    return resultArray.compactMap{ $0 }
                case .failure(let error):
                    #if DEBUG
                        print(error)
                    #endif
                    throw NetworkError.invalidContent
                }
                
            } catch {
                #if DEBUG
                    print(error)
                #endif
                throw NetworkError.unexpectedStatusCode
            }
        }
        
        activeRequests[query] = request
        
        return try await request.value
    }
    
    func searchShowAliases(id: String) async throws -> [String] {
        do {
            let result = try await requestFromEndpoint(endpoint: ShowsEndpoint.searchAliases(id: id), responseModel: JsonAliases.self)
//            let result = try await requestFromBundleFile(filename: "aliases", responseModel: JsonAliases.self)

            switch result {
            case .success(let aliasesResponse):
                return aliasesResponse.compactMap { $0.name }
            case .failure(let error):
                #if DEBUG
                    print(error)
                #endif
                return []
            }
        }
        catch {
            #if DEBUG
                print(error)
            #endif
            throw NetworkError.invalidContent
        }
    }
}

extension ShowsNetworkService {
    func obtainRemoteImage(url: String) async throws -> UIImage {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidUrl
        }
        
        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200,
              let mimeType = response.mimeType, mimeType.hasPrefix("image"),
              let image = UIImage(data: data)
        else {
            guard let image = UIImage(named: "missing") else {
                throw NetworkError.invalidContent
            }
            return image
        }
        
        return image
    }
}
