//
//  AddOnDetailsViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 30.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class AddOnDetailsViewModelTests: XCTestCase {
    var viewModel: AddOnDetailsViewModel!
    var eventService: BookingEventsNotificationService!
    var mockGetAddOnsUseCase: GetAddOnsUseCaseProtocol!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        eventService = BookingEventsNotificationService()
        mockGetAddOnsUseCase = MockGetAddOnsUseCase()
        viewModel = AddOnDetailsViewModel(
            addOn: .init(),
            getAddOnsUseCase: mockGetAddOnsUseCase,
            bookingEventsNotificationService: eventService
        )
    }

    // MARK: - TearDown
    override func tearDown() {
        viewModel = nil
        eventService = nil
        mockGetAddOnsUseCase = nil
        super.tearDown()
    }
    
	@MainActor func testOnPurchaseSetsUpBookingNavigationCoordinator() {
        // Given
        viewModel.purchase()
        
        // Assert
        XCTAssertEqual(viewModel.isShowingPurchaseSheet, true)
        XCTAssertEqual(viewModel.navigationCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.getCurrentRoute(), PurchaseSheetNavigationRoute.landing)
    }
}
