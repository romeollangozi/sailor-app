//
//  CancelAppointmentUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 5.2.25.
//


import Foundation
import XCTest

@testable import Virgin_Voyages

final class CancelAppointmentUseCaseTests: XCTestCase {
    var useCase: CancelAppointmentUseCase!
    var mockCancelAppointmentRepository: MockCancelAppointmentRepository!
    var mockCurrentSailorManager: MockCurrentSailorManager!

    override func setUp() {
        super.setUp()
        mockCancelAppointmentRepository = MockCancelAppointmentRepository()
        mockCurrentSailorManager = MockCurrentSailorManager()
        
        useCase = CancelAppointmentUseCase(
            cancelAppointmentRepository: mockCancelAppointmentRepository,
            currentSailorManager: mockCurrentSailorManager
        )
    }

    override func tearDown() {
        useCase = nil
        mockCancelAppointmentRepository = nil
        mockCurrentSailorManager = nil
        super.tearDown()
    }

    func testExecuteShouldCancelAppointmentSuccessfully() async throws {
        // Arrange
        
        let guest = CancelAppointmentInputModel.PersonDetail(personId: "43242-40043293424-4",
                                                             guestId: "14242-424-42-444",
                                                             reservationNumber: "42343",
                                                             status: "CANCELED")
        let inputModel = CancelAppointmentInputModel(
            appointmentLinkId: "12345",
            categoryCode: "ACTIVITY",
            numberOfGuests: 1,
            isRefund: true,
            personDetails: [guest]
        )

        let mockSailor = CurrentSailor.sample()
        
        mockCurrentSailorManager.lastSailor = mockSailor
        mockCancelAppointmentRepository.mockResult = CancelAppointment.sample()

        // Act
        let result = try await useCase.execute(inputModel: inputModel)

        // Assert
        XCTAssertEqual(result.appointmentLinkId, "44444-55555-66aa66-7777")
        XCTAssertEqual(result.paymentStatus, "CANCELED")
        XCTAssertNil(result.message)
    }

    func testExecuteShouldThrowError() async {
        // Arrange
 
        let inputModel = CancelAppointmentInputModel.empty()
        let mockSailor = CurrentSailor.sample()
        
        mockCurrentSailorManager.lastSailor = mockSailor
        mockCancelAppointmentRepository.shouldThrowError = true

        // Act & Assert
        do {
            _ = try await useCase.execute(inputModel: inputModel)
            XCTFail("Expected error to be thrown, but it was not.")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
