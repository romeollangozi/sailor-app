//
//  MarkNotificationAsReadUseCaseTest.swift
//  Virgin VoyagesTests
//
//  Created by TX on 27.11.24.
//

import XCTest
@testable import Virgin_Voyages

final class MarkNotificationsAsReadUseCaseTests: XCTestCase {
    
    var useCase: MarkNotificationsAsReadUseCase!
    var mockRepository: MockNotificationMessagesRepository!
    
    override func setUp() {
        super.setUp()
        
        // Set up mock repository
        mockRepository = MockNotificationMessagesRepository()
        
        // Initialize the use case with the mock repository
        useCase = MarkNotificationsAsReadUseCase(repository: mockRepository)
    }

    override func tearDown() {
        // Reset mocks and use case
        mockRepository = nil
        useCase = nil
        
        super.tearDown()
    }
    
    func testExecuteReturnsSuccess() async {
        // Given
        let notificationIds = ["1", "2", "3"]
        mockRepository.shouldReturnSuccess = true
        
        // When: Execute is called
        let result = await useCase.execute(notificationIds: notificationIds)
        
        // Then: Result should be success
        XCTAssertTrue(result, "The execute function should return true when notifications are marked successfully.")
    }
    
    func testExecuteReturnsFailureWhenErrorOccurs() async {
        // Given
        let notificationIds = ["1", "2", "3"]
        mockRepository.shouldReturnError = true
        
        // When: Execute is called
        let result = await useCase.execute(notificationIds: notificationIds)
        
        // Then: Result should be failure
        XCTAssertFalse(result, "The execute function should return false when there is an error marking notifications as read.")
    }
}
