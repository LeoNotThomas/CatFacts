//
//  CatFact-Endpoint.swift
//  CatFacts
//
//  Created by Thomas (privat) Leonhardt on 02.08.23.
//

import Foundation

enum CatEndpoint: Endpoint {
    case catFacts
    var method: String {
        switch self {
        case .catFacts:
            return HTTPMethod.get.rawValue
        }
    }
    
    var scheme: String {
        switch self {
        case .catFacts:
            return HTTPSchema.https.rawValue
        }
    }
    
    var baseUrl: String {
        NetworkParts.baseUrl.rawValue
    }
    
    var path: String {
        switch self {
        case .catFacts:
            return NetworkPaths.catFactsPath.rawValue
        }
    }
    
    var parameters: [URLQueryItem] {
        []
    }
    
    
}
