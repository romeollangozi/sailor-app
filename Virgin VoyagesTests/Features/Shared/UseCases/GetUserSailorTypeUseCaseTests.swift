//
//  GetSailorTypeUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 10.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetSailorTypeUseCaseTests: XCTestCase {
    
    var useCase: GetSailorTypeUseCase!
    var mockSailorManager: MockCurrentSailorManager!

    override func setUp() {
        super.setUp()
        mockSailorManager = MockCurrentSailorManager()
        useCase = GetSailorTypeUseCase(currentSailorManager: mockSailorManager)
    }

    override func tearDown() {
        useCase = nil
        mockSailorManager = nil
        super.tearDown()
    }

    func testExecuteReturnsCorrectSailorType() {
        mockSailorManager.lastSailor = .sample()
        let result = useCase.execute()
        XCTAssertEqual(result, .standard, "Expected sailor type to be guest")
    }
}
