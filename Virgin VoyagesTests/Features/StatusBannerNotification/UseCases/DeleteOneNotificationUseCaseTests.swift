//
//  DeleteOneNotificationUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 8/1/25.
//

import XCTest
@testable import Virgin_Voyages

final class DeleteOneNotificationUseCaseTests: XCTestCase {
    
    private var mockRepository: MockStatusBannersNotificationsRepository!
    private var mockCurrentSailorManager: MockCurrentSailorManager!
    private var useCase: DeleteOneNotificationUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockStatusBannersNotificationsRepository()
        mockCurrentSailorManager = MockCurrentSailorManager()
        useCase = DeleteOneNotificationUseCase(statusBannersNotificationsRepositoryProtocol: mockRepository,
                                               currentSailorManager: mockCurrentSailorManager)
    }
    
    override func tearDown() {
        mockRepository = nil
        mockCurrentSailorManager = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecuteSuccess() async throws {
        
        let notificationId = UUID().uuidString
        let sampleSailor = CurrentSailor.sample()
        
        mockCurrentSailorManager.lastSailor = sampleSailor
        
        let result = try await useCase.execute(notificationId: notificationId)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(mockRepository.passednotificationId, notificationId)
        XCTAssertEqual(mockRepository.passedVoyageNumber, sampleSailor.voyageNumber)
    }
    
    func testExecuteThrowsErrorWhenRepositoryThrowsError() async throws {
        
        let notificationId = UUID().uuidString
        
        mockRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute(notificationId: notificationId)
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
