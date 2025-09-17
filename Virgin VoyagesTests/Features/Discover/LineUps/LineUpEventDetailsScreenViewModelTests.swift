//
//  LineUpEventDetailsScreenViewModelTest.swift
//  Virgin VoyagesTests
//
//  Created by TX on 30.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class LineUpEventDetailsScreenViewModelTest: XCTestCase {
    var viewModel: LineUpEventDetailsScreenViewModel!
    var eventService: BookingEventsNotificationService!
    var mockGetLineUpDetailsUseCase: MockGetLineUpDetailsUseCase!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        eventService = BookingEventsNotificationService()
        mockGetLineUpDetailsUseCase = MockGetLineUpDetailsUseCase()
        viewModel = LineUpEventDetailsScreenViewModel(
            event: .sample(),
            bookingEventsNotificationService: eventService,
            lineUpDetailsUseCase: mockGetLineUpDetailsUseCase
        )
    }

    // MARK: - TearDown
    override func tearDown() {
        viewModel = nil
        eventService = nil
        mockGetLineUpDetailsUseCase = nil
        super.tearDown()
    }
    
	@MainActor func testOnAddToAgendaSetsUpBookingNavigationCoordinator() {
        // Given
        viewModel.addToAgenda()
        
        // Assert
        XCTAssertEqual(viewModel.showBookEventSheet, true)
        XCTAssertEqual(viewModel.navigationCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.getCurrentRoute(), PurchaseSheetNavigationRoute.landing)
    }
}
