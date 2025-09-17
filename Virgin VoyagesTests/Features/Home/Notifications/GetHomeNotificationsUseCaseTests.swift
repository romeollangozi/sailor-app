//
//  GetHomeNotificationsUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 16.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetHomeNotificationsUseCaseTests: XCTestCase {
    private var mockHomeNotificationsRepository: MockHomeNotificationsRepository!
    private var mockCurrentSailorManager: MockCurrentSailorManager!
    private var useCase: GetHomeNotificationsUseCase!
    
    override func setUp() {
        super.setUp()
        mockHomeNotificationsRepository = MockHomeNotificationsRepository()
        mockCurrentSailorManager = MockCurrentSailorManager()
        useCase = GetHomeNotificationsUseCase(
            homeNotificationsRepository: mockHomeNotificationsRepository,
            currentSailorManager: mockCurrentSailorManager
        )
    }
    
    override func tearDown() {
        mockHomeNotificationsRepository = nil
        mockCurrentSailorManager = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        let mockHomeNotifications = HomeNotificationsSection.sample()
        let mockSailor = CurrentSailor.sample()
        
        mockCurrentSailorManager.lastSailor = mockSailor
        mockHomeNotificationsRepository.homeNotification = mockHomeNotifications
        
        let result = try await useCase.execute()
        XCTAssertEqual(result, mockHomeNotifications)
    }
    
    func testExecute_Error() async {
        mockHomeNotificationsRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error but did not receive one.")
        } catch {
            XCTAssertTrue(error is VVDomainError)
        }
    }
}
