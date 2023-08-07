//
//  MockApiCaller.swift
//  CatFactsTests
//
//  Created by Thomas (privat) Leonhardt on 06.08.23.
//

import Foundation

enum MockApiCallerType {
    case validCatFactResponse
    case parsingError
    case urlError
}

protocol MockApiCallerProtocol: AnyObject {
    var callerType: MockApiCallerType { get }
    var returnValue: Any? { get set }
}

struct MockApiCaller: APIClientProtocol {
    var returnValue: Any?
    var callerType: MockApiCallerType
    
    func fetch<T>(_ type: T.Type, endpoint: Endpoint) async throws -> T where T : Decodable {
        switch callerType {
        case .validCatFactResponse:
            return returnValue as! T
        case .parsingError:
            throw NetworkError.dataParsingError
        default:
            throw NetworkError.urlError
        }
    }
    
    init(callerType: MockApiCallerType) {
        self.callerType = callerType
    }
    
    static func viewModel(moc: MockApiCaller) -> CatFactsViewModel {
        CatFactsViewModel(apiCaller: moc)
    }
}
