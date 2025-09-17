//
//  GetTreatmentReceiptUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 6.2.25.
//


import Foundation
import XCTest

@testable import Virgin_Voyages

final class GetTreatmentReceiptUseCaseTests: XCTestCase {
    var mockRepository: MockTreatmentReceiptRepository!
    var useCase: GetTreatmentReceiptUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockTreatmentReceiptRepository()
        useCase = GetTreatmentReceiptUseCase(treatmentReceiptRepository: mockRepository, currentSailorManager: MockCurrentSailorManager())
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        let mockAppointment = TreatmentReceipt.sample()
        mockRepository.mockTreatmentReceipt = mockAppointment
        
        let result = try await useCase.execute(appointmentId: "000")
        
        XCTAssertEqual(result.id, mockAppointment.id)
        XCTAssertEqual(result.imageUrl, mockAppointment.imageUrl)
        XCTAssertEqual(result.category, mockAppointment.category)
        XCTAssertEqual(result.pictogramUrl, mockAppointment.pictogramUrl)
        XCTAssertEqual(result.name, mockAppointment.name)
        XCTAssertEqual(result.startDateTime, mockAppointment.startDateTime)
        XCTAssertEqual(result.location, mockAppointment.location)
        XCTAssertEqual(result.shortDescription, mockAppointment.shortDescription)
        XCTAssertEqual(result.longDescription, mockAppointment.longDescription)
        XCTAssertEqual(result.sailors.count, mockAppointment.sailors.count)
        
        for (index, sailor) in result.sailors.enumerated() {
            let mockSailor = mockAppointment.sailors[index]
            XCTAssertEqual(sailor.id, mockSailor.id)
            XCTAssertEqual(sailor.guestId, mockSailor.guestId)
            XCTAssertEqual(sailor.reservationGuestId, mockSailor.reservationGuestId)
            XCTAssertEqual(sailor.reservationNumber, mockSailor.reservationNumber)
            XCTAssertEqual(sailor.name, mockSailor.name)
            XCTAssertEqual(sailor.profileImageUrl, mockSailor.profileImageUrl)
        }
    }

    func testExecute_ThrowsNotFoundError() async {
        
        mockRepository.mockTreatmentReceipt = nil
        
        do{
            _ = try await useCase.execute(appointmentId: "invalid-id")
            XCTFail("Expected error")
        }catch let error as VVDomainError{
            XCTAssertEqual(error, .genericError)
        }catch{
            XCTFail("UnExpected error: \(error)")
        }
    }
}
