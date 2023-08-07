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

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testWhenURLComponentGivenCatFactsEndPointThenUrlCatFact() {
        // WHEN
        var components = URLComponents()
        // GIVEN
        let endpoint = CatEndpoint.catFacts
        components.scheme = endpoint.scheme
        components.host = endpoint.baseUrl
        components.path = endpoint.path
        // THEN
        XCTAssert(components.url?.absoluteString == "https://catfact.ninja/fact", "url string is invalid" )
    }
    
    func testWhenCallerGivenCatFactThenCatFactListIsNotEmpty() {
        // WHEN
        var moc = MockApiCaller(callerType: .validCatFactResponse)
        let fact = CatFact(fact: "Test", length: 4)
        moc.returnValue = fact
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
        var moc = MockApiCaller(callerType: .urlError)
        let fact = CatFact(fact: "Test", length: 4)
        moc.returnValue = fact
        let sut = CatFactsViewModel(apiCaller: moc)
        
        let expectation = XCTestExpectation(description: "Get Error")
        sut.next()
        sut.$showError
            .filter { $0 }
            .sink { error in
                XCTAssert(error)
                expectation.fulfill()
            }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
}
