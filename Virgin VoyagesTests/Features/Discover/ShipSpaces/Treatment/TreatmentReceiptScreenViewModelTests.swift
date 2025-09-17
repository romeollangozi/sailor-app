//
//  TreatmentReceiptScreenViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 30.5.25.
//

import XCTest
@testable import Virgin_Voyages

@MainActor
final class TreatmentReceiptScreenViewModelTests: XCTestCase {
    private var viewModel: TreatmentReceiptScreenViewModel!
    private var eventService: BookingEventsNotificationService!
    private var mockGetTreatmentDetailsUseCase: MockGetTreatmentDetailsUseCase!
    private var mockGetTreatmentReceiptUseCase: MockGetTreatmentReceiptUseCase!
    private var mockLastKnownSailorConnectionLocationRepository : MockLastKnownSailorConnectionLocationRepository!
    private var mockSailorsUseCase: MockGetMySailorsUseCase!

    // MARK: - Setup
    override func setUp() {
        super.setUp()
        eventService = BookingEventsNotificationService()
        mockGetTreatmentDetailsUseCase = MockGetTreatmentDetailsUseCase()
        mockLastKnownSailorConnectionLocationRepository = MockLastKnownSailorConnectionLocationRepository()
        mockGetTreatmentReceiptUseCase = MockGetTreatmentReceiptUseCase()
        mockSailorsUseCase = MockGetMySailorsUseCase()
        
        viewModel = TreatmentReceiptScreenViewModel(
                appointmentId: "",
                getTreatmentReceiptUseCase: mockGetTreatmentReceiptUseCase,
                getTreatmentDetailsUseCase: mockGetTreatmentDetailsUseCase,
                lastKnownSailorConnectionLocationRepository: mockLastKnownSailorConnectionLocationRepository,
                getMySailorsUseCase: mockSailorsUseCase,
                bookingEventsNotificationService: eventService
            )
    }

    // MARK: - TearDown
    override func tearDown() {
        viewModel = nil
        eventService = nil
        mockGetTreatmentDetailsUseCase = nil
        mockGetTreatmentReceiptUseCase = nil
        mockSailorsUseCase = nil
        super.tearDown()
    }
    
    func testOnAppear_SuccessfulLoad() async {
        let mockAppointment = TreatmentReceiptModel.sample()
        let mockAvailableSailors = SailorModel.samples()
        mockGetTreatmentReceiptUseCase.result = mockAppointment
        mockSailorsUseCase.mockResponse = mockAvailableSailors

        viewModel.onAppear()
        
        let expectation = expectation(description: "Wait for screenState to become .content")
          Task {
              while self.viewModel.screenState != .content {
                  try? await Task.sleep(nanoseconds: 100_000_000)
              }
              expectation.fulfill()
          }
            
          await fulfillment(of: [expectation], timeout: 5.0)

        XCTAssertEqual(viewModel.treatmentReceiptModel.id, mockAppointment.id)
        XCTAssertEqual(viewModel.treatmentReceiptModel.name, mockAppointment.name)
        XCTAssertEqual(viewModel.availableSailors.count, 2)
        XCTAssertEqual(viewModel.availableSailors, mockAvailableSailors)
    }

    
	func testOnEditBookingSetsUpBookingNavigationCoordinator() {
        // Arrange
        mockGetTreatmentDetailsUseCase.result = .sample()
        mockGetTreatmentReceiptUseCase.result = .sample()
        // Act
        viewModel.editBooking()
        
        // Assert
        XCTAssertEqual(viewModel.showEditFlow, true)
        XCTAssertEqual(viewModel.navigationCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.getCurrentRoute(), PurchaseSheetNavigationRoute.landing)
    }
}
