//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 23.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetHomePlannerUseCaseTests: XCTestCase {
    private var mockHomePlannerRepository: MockHomePlannerRepository!
    private var mockCurrentSailorManager: MockCurrentSailorManager!
    private var useCase: GetHomePlannerUseCase!
    
    override func setUp() {
        super.setUp()
        mockHomePlannerRepository = MockHomePlannerRepository()
        mockCurrentSailorManager = MockCurrentSailorManager()
        useCase = GetHomePlannerUseCase(
            homePlannerRepository: mockHomePlannerRepository,
            currentSailorManager: mockCurrentSailorManager
        )
    }
    
    override func tearDown() {
        mockHomePlannerRepository = nil
        mockCurrentSailorManager = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        let mockHomePlanner = HomePlannerSection.sample()
        let mockSailor = CurrentSailor.sample()
        
        mockCurrentSailorManager.lastSailor = mockSailor
        mockHomePlannerRepository.homePlanner = mockHomePlanner
        
        let result = try await useCase.execute()
        XCTAssertEqual(result, mockHomePlanner)
    }
    
    func testExecute_Error() async {
        mockHomePlannerRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error but did not receive one.")
        } catch {
            XCTAssertTrue(error is VVDomainError)
        }
    }
}
