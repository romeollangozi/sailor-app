//
//  GetHomePageDataUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 13.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetHomePageDataUseCaseTests: XCTestCase {
    
    var useCase: GetHomePageDataUseCase!
    var mockRepository: MockHomePageRepository!
    var mockVoyageRepository: MockMyVoyageRepository!
    var mockSailorManager: MockCurrentSailorManager!

    override func setUp() {
        super.setUp()
        mockRepository = MockHomePageRepository()
        mockVoyageRepository = MockMyVoyageRepository()
        mockSailorManager = MockCurrentSailorManager()
        useCase = GetHomePageDataUseCase(
            repository: mockRepository,
            myVoyageRepository: mockVoyageRepository,
            currentSailorManager: mockSailorManager
        )
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        mockVoyageRepository = nil
        mockSailorManager = nil
        super.tearDown()
    }

    func testExecuteWithValidSailingModeReturnsHomePage() async throws {
        mockRepository.mockHomePage = HomePage(sections: [HomeHeader.init(id: "", title: "", topBarTitle: "", topBarSubtitle: "", headerTitle: "", headerSubtitle: "", backgroundImageUrl: "", reservationNumber: "", cabinNumber: "", gangwayOpeningTime: "", gangwayClosingTime: "", shipTimeOffset: -300)])
        
        mockSailorManager.lastSailor = CurrentSailor.sample()
        
        let result = try await useCase.execute(forSailingMode: .shipBoardSeaDay)
        
        XCTAssertNotNil(mockRepository.mockHomePage)
        
    }
    
    func testExecuteThrowsErrorWhenRepositoryFails() async {
        mockRepository.shouldThrowError = true
        mockRepository.errorToThrow = VVDomainError.genericError
        mockSailorManager.lastSailor = CurrentSailor.sample()

        do {
            _ = try await useCase.execute(forSailingMode: .shipBoardSeaDay)
            XCTFail("Expected error but got a successful response")
        } catch {
            XCTAssertEqual(error as? VVDomainError, VVDomainError.genericError, "Expected VVDomainError.genericError")
        }
    }
}
