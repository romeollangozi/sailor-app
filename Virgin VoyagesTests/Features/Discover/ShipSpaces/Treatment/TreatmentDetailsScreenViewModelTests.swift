//
//  TreatmentDetailsScreenViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 30.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class TreatmentDetailsScreenViewModelTests: XCTestCase {
    var viewModel: TreatmentDetailsScreenViewModel!
    var eventService: BookingEventsNotificationService!
    var mockGetTreatmentDetailsUseCase: MockGetTreatmentDetailsUseCase!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        eventService = BookingEventsNotificationService()
        mockGetTreatmentDetailsUseCase = MockGetTreatmentDetailsUseCase()
        viewModel = TreatmentDetailsScreenViewModel(
            treatmentId: "",
            getTreatmentDetailsUseCase: mockGetTreatmentDetailsUseCase,
            bookingEventsNotificationService: eventService
        )
    }

    // MARK: - TearDown
    override func tearDown() {
        viewModel = nil
        eventService = nil
        mockGetTreatmentDetailsUseCase = nil
        super.tearDown()
    }
    
	@MainActor func testOnBookTappedSetsUpBookingNavigationCoordinator() {
        // Arrange
        mockGetTreatmentDetailsUseCase.result = .sample()
        viewModel.treatmentDetails = .sample()
        
        // Act
        viewModel.book()
        
        // Assert
        XCTAssertEqual(viewModel.isPurchaseSheetPresented, true)
        XCTAssertEqual(viewModel.navigationCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.getCurrentRoute(), PurchaseSheetNavigationRoute.landing)
    }
}
