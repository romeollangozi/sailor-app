//
//  NotificationMessagesScreenViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 27.11.24.
//

import XCTest
@testable import Virgin_Voyages

final class NotificationMessagesScreenViewModelTests: XCTestCase {
    
    var viewModel: NotificationMessagesScreenViewModel!
    var mockMarkNotificationsAsReadUseCase: MockMarkNotificationsAsReadUseCase!
    
    override func setUp() {
        super.setUp()
        
        // Initialize the mock repository and use case
        let mockRepository = MockNotificationMessagesRepository()
        mockMarkNotificationsAsReadUseCase = MockMarkNotificationsAsReadUseCase(repository: mockRepository)
        
        // Initialize the view model with the mock use case
        viewModel = NotificationMessagesScreenViewModel(
            messages: [
                NotificationMessageCardModel(
                    notificationId: "1",
                    title: "Message 1",
                    description: "This is the first message",
                    notificationsCountText: "1",
                    readTime: "12:00 PM",
                    isRead: false,
                    showReadUnreadIndicator: true,
                    type: .notifications,
                    notificationType: "travelparty.excursion.cancelled",
                    notificationData: "{\"activityCode\":\"BIMAUT00001\",\"currentDay\":3,\"bookingLinkId\":\"dc1f6362-6822-42e5-b9ac-24c35f36d449\",\"isBookingProcess\":false,\"appointmentId\":\"bac2f315-c178-4d79-bae1-49c5e12ac2b5\",\"currentDate\":[2025,5,21],\"categoryCode\":\"PA\"}"
                ),
                NotificationMessageCardModel(
                    notificationId: "2",
                    title: "Message 2",
                    description: "This is the second message",
                    notificationsCountText: "2",
                    readTime: "12:30 PM",
                    isRead: false,
                    showReadUnreadIndicator: true,
                    type: .notifications,
                    notificationType: "travelparty.excursion.cancelled",
                    notificationData: "{\"activityCode\":\"BIMAUT00001\",\"currentDay\":3,\"bookingLinkId\":\"dc1f6362-6822-42e5-b9ac-24c35f36d449\",\"isBookingProcess\":false,\"appointmentId\":\"bac2f315-c178-4d79-bae1-49c5e12ac2b5\",\"currentDate\":[2025,5,21],\"categoryCode\":\"PA\"}"
                )
            ],
            isVisible: true,
            viewOpacity: 1.0,
            markNotificationMessagesAsReadUseCase: mockMarkNotificationsAsReadUseCase
        )
    }

    override func tearDown() {
        // Reset mocks and view model
        mockMarkNotificationsAsReadUseCase = nil
        viewModel = nil
        
        super.tearDown()
    }
    
    func testOnAppear() {
        // When: onAppear is called
        viewModel.onAppear()
        
        // Then: The view opacity should be 1.0
        XCTAssertEqual(viewModel.viewOpacity, 1.0, "The viewOpacity should be 1.0 after onAppear is called.")
    }
    
    func testUpdateVisibilityMarksNotificationAsRead() async {
        // Given
        mockMarkNotificationsAsReadUseCase.shouldReturnSuccess = true
        let messageId = "1"
        let expectation = XCTestExpectation(description: "Async updateVisibility")

        // When: updateVisibility is called with a visible message
        await viewModel.updateVisibility(for: messageId, isVisible: true)
        // Switch on main thread
        DispatchQueue.main.async {
            // Assert: The message should be updated to isRead = true and showReadUnreadIndicator = false
            let updatedMessage = self.viewModel.messages.first { $0.id == messageId }
            XCTAssertTrue(updatedMessage?.isRead ?? false, "The message should be marked as read.")
            XCTAssertFalse(updatedMessage?.showReadUnreadIndicator ?? true, "The read/unread indicator should be hidden.")
            
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 3.0)

    }
    
    func testDismissView() {
        // Create an expectation that will be fulfilled after the delay
        let expectation = self.expectation(description: "Dismiss View")

        // When: dismissView is called
        viewModel.dismissView()

        // Wait for the delay in the dismissView method
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Then: The viewOpacity should be 0.0 after animation
            XCTAssertEqual(self.viewModel.viewOpacity, 0.0, "The viewOpacity should be 0.0 after dismissView is called.")

            // And: The visibility should be set to false after the delay
            XCTAssertEqual(self.viewModel.isVisible, false, "The isVisible should be false after the delay in dismissView.")
            
            // Fulfill the expectation after the assertions
            expectation.fulfill()
        }

        // Wait for the expectations to be fulfilled with a timeout
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testUpdateVisibilityDoesNotMarkAlreadyReadNotification() async {
        // Given: A message that is already read
        let messageId = "1"
        viewModel.messages = [
            NotificationMessageCardModel(
                notificationId: messageId,
                title: "Already Read",
                description: "This message is already read.",
                notificationsCountText: "0",
                readTime: "1:00 PM",
                isRead: true,
                showReadUnreadIndicator: false,
                type: .notifications,
                notificationType: "travelparty.excursion.cancelled",
                notificationData: "{\"activityCode\":\"BIMAUT00001\",\"currentDay\":3,\"bookingLinkId\":\"dc1f6362-6822-42e5-b9ac-24c35f36d449\",\"isBookingProcess\":false,\"appointmentId\":\"bac2f315-c178-4d79-bae1-49c5e12ac2b5\",\"currentDate\":[2025,5,21],\"categoryCode\":\"PA\"}"
            )
        ]
        
        // When: updateVisibility is called for this already read message
        await viewModel.updateVisibility(for: messageId, isVisible: true)
        
        // Then: The message should not be updated
        XCTAssertEqual(viewModel.messages.first { $0.id == messageId }?.isRead, true, "The message should still be marked as read.")
    }
    
    func testUpdateVisibilityHandlesFailureInMarkAsRead() async {
        // Given: The use case will fail
        mockMarkNotificationsAsReadUseCase.shouldReturnSuccess = false
        let messageId = "1"
        
        // When: updateVisibility is called for this message
        await viewModel.updateVisibility(for: messageId, isVisible: true)
        
        // Then: The message should not be marked as read
        XCTAssertEqual(viewModel.messages.first { $0.id == messageId }?.isRead, false, "The message should remain unread after a failure.")
    }
}
