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
    var returnValue: Any { get }
}

struct MockApiCaller: APIClientProtocol {
    var returnValue: CatFactEntity
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
        let fact = CatFactEntity(context: CatFactDataManager.shared.container.viewContext)
        fact.fact = "Test"
        fact.length = 4
        fact.id = UUID()
        fact.saveDate = .now
        self.returnValue = fact
    }
    
    static func viewModel(moc: MockApiCaller) -> CatFactsViewModel {
        CatFactsViewModel(apiCaller: moc)
    }
}
