//
//  LineUpEventReceiptViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 27.1.25.
//

import XCTest
@testable import Virgin_Voyages

@MainActor
final class LineUpEventReceiptViewModelTests: XCTestCase {
    var viewModel: LineUpEventReceiptViewModel!
    var mockLineUpAppointmentDetailsUseCase: MockGetLineUpAppointmentDetailsUseCase!
    var mockSailorsUseCase: MockGetMySailorsUseCase!

    override func setUp() {
        super.setUp()
        mockLineUpAppointmentDetailsUseCase = MockGetLineUpAppointmentDetailsUseCase()
        mockSailorsUseCase = MockGetMySailorsUseCase()

        viewModel = LineUpEventReceiptViewModel(
                  appointmentId: "12345",
                  getLineUpAppointmentDetailsUseCase: mockLineUpAppointmentDetailsUseCase,
                  getMySailorsUseCase: mockSailorsUseCase
              )
    }

    override func tearDown() {
        viewModel = nil
        mockLineUpAppointmentDetailsUseCase = nil
        mockSailorsUseCase = nil
        super.tearDown()
    }
    
    func testOnAppear_SuccessfulLoad() async {
        let mockAppointment = LineUpReceiptModel.sample()
        let mockAvailableSailors = SailorModel.samples()
        mockLineUpAppointmentDetailsUseCase.mockResponse = mockAppointment
        mockSailorsUseCase.mockResponse = mockAvailableSailors
        
        await self.viewModel.onAppear()
        
        XCTAssertEqual(viewModel.lineUpReceipt.id, mockAppointment.id)
        XCTAssertEqual(viewModel.lineUpReceipt.name, mockAppointment.name)
        XCTAssertEqual(viewModel.availableSailors.count, 2)
        XCTAssertEqual(viewModel.availableSailors, mockAvailableSailors)
    }
    
    @MainActor func testOnEditBookingTapSetsUpBookingNavigationCoordinator() {
        // Given
        viewModel.onEditBookingTapped()
        
        // Assert
        XCTAssertEqual(viewModel.showEditFlow, true)
        XCTAssertEqual(viewModel.navigationCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.getCurrentRoute(), PurchaseSheetNavigationRoute.landing)
    }
}
