//
//  VoyageSelectionScreenViewModelTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 3.6.25.
//

import XCTest
@testable import Virgin_Voyages

@MainActor
final class VoyageSelectionScreenViewModelTests: XCTestCase {

    var sut: VoyageSelectionScreenViewModel!

    // MARK: - Mock Dependencies
    var mockGetVoyageReservationsUseCase: MockGetVoyageReservationsUseCase!
    var mockLogoutUserUseCase: MockLogoutUserUseCase!
    var mockAuthenticationService: MockAuthenticationService!
    var onVoyageChanged: (String) -> Void = { _ in }
    var onCurrentVoyageSelected: () -> Void = { }

    override func setUp() {
        super.setUp()
        mockGetVoyageReservationsUseCase = MockGetVoyageReservationsUseCase()
        mockLogoutUserUseCase = MockLogoutUserUseCase()
        mockAuthenticationService = MockAuthenticationService()

        sut = VoyageSelectionScreenViewModel(
            getVoyageReservationsUseCase: mockGetVoyageReservationsUseCase,
            logoutUserUseCase: mockLogoutUserUseCase,
            authenticationService: mockAuthenticationService,
            onVoyageChanged: onVoyageChanged,
            onCurrentVoyageSelected: onCurrentVoyageSelected
        )
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_onAppear() {
        mockGetVoyageReservationsUseCase.executeResult = .sample()
    

        executeAndWaitForAsyncOperation { [self] in
            Task { sut.onAppear() }
        }

        XCTAssertEqual(sut.screenState, .content)
        XCTAssertEqual(sut.voyageReservations.pageDetails.title, "Voyage Selection")
        XCTAssertEqual(sut.voyageReservations.pageDetails.description, "You've got some sweet sails coming up — so choose which specific voyage you'd like to view below.")
        XCTAssertEqual(sut.voyageReservations.guestBookings.count, 3)
    }
    
//    func test_didTapLogout() {
//        mockLogoutUserUseCase.isExecuted = false
//        
//        executeAndWaitForAsyncOperation { [self] in
//            Task { sut.didTapLogout() }
//        }
//        XCTAssertEqual(mockLogoutUserUseCase.isExecuted, true)
//    }
    
//    func test_didTapClamABooking() {
//        
//        executeAndWaitForAsyncOperation { [self] in
//            Task { sut.didTapClamABooking() }
//        }
//        XCTAssertNil(mockAuthenticationService.reservation?.reservationId)
//    }
    
    func test_reloadReservation() {
        mockAuthenticationService.reloadedReservationNumber = "111"
        
        executeAndWaitForAsyncOperation { [self] in
            Task { sut.reloadReservation(reservationNumber: "222") }
        }
        XCTAssertEqual(mockAuthenticationService.reloadedReservationNumber, "222")
    }
}
