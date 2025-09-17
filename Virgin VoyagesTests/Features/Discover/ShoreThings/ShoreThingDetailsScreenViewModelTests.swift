//
//  ShoreThingDetailsScreenViewModelTests.swift
//  Virgin Voyages
//
//  Created by TX on 30.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class ShoreThingDetailsScreenViewModelTests: XCTestCase {
    private var viewModel: ShoreThingDetailsScreenViewModel!
    private var eventService: BookingEventsNotificationService!
    private var mockGetShoreThingItemUseCase: MockGetShoreThingItemUseCase!

    // MARK: - Setup
    override func setUp() {
        super.setUp()
        eventService = BookingEventsNotificationService()
        mockGetShoreThingItemUseCase = MockGetShoreThingItemUseCase()
        
        viewModel = ShoreThingDetailsScreenViewModel(
            shoreThingItem: ShoreThingItem.sample(),
            getShoreThingItemUseCase: mockGetShoreThingItemUseCase,
            bookingEventsNotificationService: eventService
        )
    }

    // MARK: - TearDown
    override func tearDown() {
        viewModel = nil
        eventService = nil
        mockGetShoreThingItemUseCase = nil
        super.tearDown()
    }
    
	@MainActor func testOnPurchaseTapSetsUpBookingNavigationCoordinator() {
        // Arrange
        mockGetShoreThingItemUseCase.result = .sample()
        
        // Act
        viewModel.onPurchaseTapped()
        
        // Assert
        XCTAssertEqual(viewModel.showBookEventSheet, true)
        XCTAssertEqual(viewModel.navigationCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.getCurrentRoute(), PurchaseSheetNavigationRoute.landing)
    }
    
    func test_onAppear_setsScreenStateToContent() {
        let viewModel = ShoreThingDetailsScreenViewModel(shoreThingItem: .sample())
        viewModel.onAppear()
        XCTAssertEqual(viewModel.screenState, .content)
    }

    func test_ctaTitle_returnsCorrectTitleForSlotStatus() {
        let mockItem = ShoreThingItem.sample(selectedSlot: .sample(status: .soldOut))
        
        let viewModel = ShoreThingDetailsScreenViewModel(shoreThingItem: mockItem)
        XCTAssertEqual(viewModel.ctaTitle, SlotStatus.soldOut.titleForCTA)
    }

    func test_isBookAvailable_returnsFalseWhenSlotSoldOut() {
        let mockItem = ShoreThingItem.sample(selectedSlot: .sample(status: .soldOut))
        
        let viewModel = ShoreThingDetailsScreenViewModel(shoreThingItem: mockItem)
        XCTAssertFalse(viewModel.isBookAvailable)
    }

    
	@MainActor func test_onPurchaseTapped_setsShowPreVoyageBookingStoppedWhenFlagged() {
        let mockItem = ShoreThingItem.sample(isPreVoyageBookingStopped: true)

        let viewModel = ShoreThingDetailsScreenViewModel(shoreThingItem: mockItem)
        viewModel.onPurchaseTapped()

        XCTAssertTrue(viewModel.showPreVoyageBookingStopped)
        XCTAssertNil(viewModel.bookingSheetViewModel)
    }

	@MainActor func test_onPurchaseTapped_setsBookingSheetViewModel_whenAllowed() {
        let mockItem = ShoreThingItem.sample()
        let viewModel = ShoreThingDetailsScreenViewModel(shoreThingItem: mockItem)

        viewModel.onPurchaseTapped()

        XCTAssertNotNil(viewModel.bookingSheetViewModel)
        XCTAssertEqual(viewModel.bookingSheetViewModel?.title, mockItem.name)
    }
}
