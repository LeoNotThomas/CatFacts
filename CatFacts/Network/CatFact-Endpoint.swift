//
//  CatFact-Endpoint.swift
//  CatFacts
//
//  Created by Thomas (privat) Leonhardt on 02.08.23.
//

import Foundation

enum CatEndpoint: Endpoint {
    case catFact
    var method: String {
        switch self {
        case .catFact:
            return HTTPMethod.get.rawValue
        }
    }
    
    var scheme: String {
        switch self {
        case .catFact:
            return HTTPSchema.https.rawValue
        }
    }
    
    var baseUrl: String {
        NetworkParts.baseUrl.rawValue
    }
    
    var path: String {
        switch self {
        case .catFact:
            return NetworkPaths.catFactsPath.rawValue
        }
    }
    
    var parameters: [URLQueryItem] {
        []
    }
    
    
}
