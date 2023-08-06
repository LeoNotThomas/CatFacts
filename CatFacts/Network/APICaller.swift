//
//  APICaller.swift
//  CatFacts
//
//  Created by Thomas (privat) Leonhardt on 03.08.23.
//

import Foundation
import Combine

protocol APIClientProtocol {
    func fetch<T: Decodable>(_ type: T.Type, endpoint: Endpoint) async throws -> T
}

struct APICaller: APIClientProtocol {
    func fetch<T: Decodable>(_ type: T.Type, endpoint: Endpoint) async throws -> T {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.baseUrl
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.parameters
        
        guard let url = urlComponents.url else {
            throw NetworkError.urlError
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let fetchedData = try? JSONDecoder().decode(type.self, from: data) else {
            throw NetworkError.dataParsingError
        }
        
        return fetchedData
    }
    
    
}
