//
//  EateryReceiptScreenViewModelTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 27.8.25.
//

import XCTest
@testable import Virgin_Voyages

final class EateryReceiptScreenViewModelTests: XCTestCase {
    var viewModel: EateryReceiptScreenViewModel!
    var mockEateryAppointmentDetailsUseCase: MockGetEateryAppointmentDetailsUseCase!
    var mockSailorsUseCase: MockGetMySailorsUseCase!

    override func setUp() {
        super.setUp()
        mockEateryAppointmentDetailsUseCase = MockGetEateryAppointmentDetailsUseCase()
        mockSailorsUseCase = MockGetMySailorsUseCase()
     
        viewModel = EateryReceiptScreenViewModel(
            appointmentId: "12345",
            getEateryAppointmentDetailsUseCase: mockEateryAppointmentDetailsUseCase,
            getMySailorsUseCase: mockSailorsUseCase
        )
    }

    override func tearDown() {
        viewModel = nil
        mockEateryAppointmentDetailsUseCase = nil
        mockSailorsUseCase = nil
        super.tearDown()
    }

    func testOnAppear_SuccessfulLoad() async {
        let mockAppointment = EateryAppointmentDetails.sample()
        let mockAvailableSailors = SailorModel.samples()
        mockEateryAppointmentDetailsUseCase.mockResponse = mockAppointment
        mockSailorsUseCase.mockResponse = mockAvailableSailors

        executeAndWaitForAsyncOperation {
            self.viewModel.onAppear()
        }

        XCTAssertEqual(viewModel.appointmentDetails.id, mockAppointment.id)
        XCTAssertEqual(viewModel.appointmentDetails.name, mockAppointment.name)
        XCTAssertEqual(viewModel.availableSailors.count, 2)
        XCTAssertEqual(viewModel.availableSailors, mockAvailableSailors)
    }
}
