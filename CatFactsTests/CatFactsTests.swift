//
//  CatFactsTests.swift
//  CatFactsTests
//
//  Created by Thomas (privat) Leonhardt on 02.08.23.
//

import XCTest
@testable import CatFacts
import Combine

final class CatFactsTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWhenURLComponentGivenCatFactsEndPointThenUrlCatFact() {
        // WHEN
        var components = URLComponents()
        // GIVEN
        let endpoint = CatEndpoint.catFact
        components.scheme = endpoint.scheme
        components.host = endpoint.baseUrl
        components.path = endpoint.path
        // THEN
        XCTAssert(components.url?.absoluteString == "https://catfact.ninja/fact", "url string is invalid" )
    }
    
    func testWhenCallerGivenCatFactThenCatFactListIsNotEmpty() {
        // WHEN
        let moc = MockApiCaller(callerType: .validCatFactResponse)
        let sut = CatFactsViewModel(apiCaller: moc)
        
        let expectation = XCTestExpectation(description: "Get Fact")
        sut.next()
        sut.$facts.dropFirst()
            .sink { catfacts in
                // THEN
                XCTAssert(!catfacts.isEmpty)
                expectation.fulfill()
            }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testWhenCallerGivenErrorThenErrorIsFilled() {
        // WHEN
        let moc = MockApiCaller(callerType: .urlError)
        let sut = CatFactsViewModel(apiCaller: moc)
        
        let expectation = XCTestExpectation(description: "Get Error")
        sut.next()
        sut.$showError
            .filter { $0 }
            .sink { error in
                // THEN
                XCTAssert(error)
                expectation.fulfill()
            }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
}
