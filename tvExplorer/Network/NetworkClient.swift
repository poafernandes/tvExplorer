//
//  NetworkClient.swift
//  tvExplorer
//
//  Created by Alexandre Porto Alegre Fernandes on 12/05/23.
//

import Foundation

protocol NetworkClient {
    func requestFromEndpoint<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> Result<T, NetworkError>
    func requestFromBundleFile<T: Decodable>(filename: String, responseModel: T.Type) async throws -> Result<T, NetworkError>
}

extension NetworkClient {
    func requestFromEndpoint<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> Result<T, NetworkError> {
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        
        guard ResponseStatus.successful.contains(statusCode) else {
            if (response as? HTTPURLResponse)?.statusCode == ResponseStatus.unauthorized
            {
                throw NetworkError.unauthorized
            }
            throw NetworkError.unexpectedStatusCode
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedResponse)
        }
        catch {
            #if DEBUG
                print(error)
            #endif
            throw NetworkError.decoding
        }
        
    }
    
    func requestFromBundleFile<T: Decodable>(filename: String, responseModel: T.Type) async throws -> Result<T, NetworkError> {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NetworkError.invalidUrl
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedResponse)
        }
        catch {
            #if DEBUG
                print(error)
            #endif
            return .failure(NetworkError.decoding)
        }
    }
}

enum NetworkError: Error {
    case invalidUrl
    case unexpectedStatusCode
    case unauthorized
    case decoding
    case invalidContent
    
    var errorMessage: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .decoding:
            return "Error while decoding response"
        case .unauthorized:
            return "Unauthorized access to requested data"
        default:
            return "Unexpected error"
        }
    }
}

enum ResponseStatus {
    static let successful = 200...299
    static let unauthorized = 401
}
