//
//  NotificationsViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 11.7.25.
//

import XCTest
@testable import Virgin_Voyages

final class NotificationsViewModelTests: XCTestCase {

    var mockGetAllNotificationsUseCase: MockGetAllNotificationsUseCase!
    var mockMarkNotificationsAsReadUseCase: MockMarkNotificationsAsReadUseCase!
    var mockGetUserApplicationStatusUseCase: MockGetUserApplicationStatusUseCase!
    var mockDispatcher: MockDeepLinkNotificationDispatcher!
    var viewModel: NotificationsViewModel!

    override func setUp() {
        super.setUp()
        mockGetAllNotificationsUseCase = MockGetAllNotificationsUseCase()
        mockMarkNotificationsAsReadUseCase = MockMarkNotificationsAsReadUseCase()
        mockGetUserApplicationStatusUseCase = MockGetUserApplicationStatusUseCase()
        mockDispatcher = MockDeepLinkNotificationDispatcher()

        viewModel = NotificationsViewModel(
            markAsReadUseCase: mockMarkNotificationsAsReadUseCase,
            getUserApplicationStatusUseCase: mockGetUserApplicationStatusUseCase,
            deepLinkNotificationDispatcher: mockDispatcher,
            getAllNotificationsUseCase: mockGetAllNotificationsUseCase
        )
    }

    override func tearDown() {
        mockGetAllNotificationsUseCase = nil
        mockMarkNotificationsAsReadUseCase = nil
        mockGetUserApplicationStatusUseCase = nil
        mockDispatcher = nil
        viewModel = nil
        super.tearDown()
    }

    func test_OnAppear_SuccessfulLoad() {
        mockGetAllNotificationsUseCase.result = Notifications.sample()

        executeAndWaitForAsyncOperation {
            self.viewModel.onAppear()
        }

        XCTAssertEqual(viewModel.notifications.count, 1)
        XCTAssertEqual(viewModel.viewState, .finished)
    }

    func test_FetchNextPageOfNotifications() {
        let firstPageItem = Notifications.NotificationItem.sample().copy(id: "1")
        let secondPageItem = Notifications.NotificationItem.sample().copy(id: "2")

        viewModel.notifications = [firstPageItem]

        mockGetAllNotificationsUseCase.result = .init(items: [secondPageItem], hasMore: true)

        executeAndWaitForAsyncOperation {
            self.viewModel.startLoadingMoreNotifications()
        }

        XCTAssertEqual(viewModel.notifications.count, 2)
        XCTAssertEqual(viewModel.notifications.last?.id, "2")
        XCTAssertEqual(viewModel.viewState, .finished)
        XCTAssertTrue(viewModel.hasMore)
    }

    func test_HandleNotificationTap() {
        viewModel.userApplicationStatus = .userLoggedInWithReservation

        let item = Notifications.NotificationItem.sample().copy(type: "travelparty.dinning.booked", isTappable: true)
        
        viewModel.handleNotificationTap(item: item)

        let expectation = expectation(description: "Wait for dispatch")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.mockDispatcher.didDispatchCount, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_Notification_ReturnsFalseForNonTappableType() {
        let item = Notifications.NotificationItem.sample().copy(isTappable: true)

        XCTAssertFalse(viewModel.hasNotificationCenterDestination(item: item))
    }

    func test_NotificationTap_WhenItemIsNotTappable() {
        let item = Notifications.NotificationItem.sample().copy(isTappable: false)

        viewModel.handleNotificationTap(item: item)

        XCTAssertEqual(self.mockDispatcher.didDispatchCount, 0)
    }
}
