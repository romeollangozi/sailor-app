//
//  ShoreThingReceiptScreenViewModelTests.swift
//  Virgin Voyages
//
//  Created by TX on 30.5.25.
//

import XCTest
@testable import Virgin_Voyages

@MainActor
final class ShoreThingReceiptScreenViewModelTests: XCTestCase {
    private var viewModel: ShoreThingReceiptScreenViewModel!
    private var eventService: BookingEventsNotificationService!
    private var mockGetShoreThingReceiptDetailsUseCase: MockGetShoreThingReceiptDetailsUseCase!
    private var mockSailorsUseCase: MockGetMySailorsUseCase!

    // MARK: - Setup
    override func setUp() {
        super.setUp()
        eventService = BookingEventsNotificationService()
        mockGetShoreThingReceiptDetailsUseCase = MockGetShoreThingReceiptDetailsUseCase()
        mockSailorsUseCase = MockGetMySailorsUseCase()
        
        viewModel = ShoreThingReceiptScreenViewModel(
            appointmentId: "",
            getShoreThingReceiptDetailsUseCase: mockGetShoreThingReceiptDetailsUseCase,
            getMySailorsUseCase: mockSailorsUseCase,
            bookingEventsNotificationService: eventService
        )
    }

    // MARK: - TearDown
    override func tearDown() {
        viewModel = nil
        eventService = nil
        mockGetShoreThingReceiptDetailsUseCase = nil
        super.tearDown()
    }
    
    func testOnAppear_SuccessfulLoad() async {
        let mockAppointment = ShoreThingReceiptDetails.sample()
        let mockAvailableSailors = SailorModel.samples()
        mockGetShoreThingReceiptDetailsUseCase.result = mockAppointment
        mockSailorsUseCase.mockResponse = mockAvailableSailors

        await self.viewModel.onAppear()

        XCTAssertEqual(viewModel.shoreThingReceipt.id, mockAppointment.id)
        XCTAssertEqual(viewModel.shoreThingReceipt.name, mockAppointment.name)
        XCTAssertEqual(viewModel.availableSailors.count, 2)
        XCTAssertEqual(viewModel.availableSailors, mockAvailableSailors)
    }
    
    @MainActor func testOnEditBookingTapSetsUpBookingNavigationCoordinator() {
        // Arrange
        mockGetShoreThingReceiptDetailsUseCase.result = .sample()
        
        // Act
        viewModel.onEditBookingTapped()
        
        // Assert
        XCTAssertEqual(viewModel.showEditBooking, true)
        XCTAssertEqual(viewModel.navigationCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.getCurrentRoute(), PurchaseSheetNavigationRoute.landing)
    }
}
