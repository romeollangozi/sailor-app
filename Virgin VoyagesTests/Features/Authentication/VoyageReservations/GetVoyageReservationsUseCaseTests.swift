//
//  GetVoyageReservationsUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 3.6.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetVoyageReservationsUseCaseTests: XCTestCase {
    private var mockVoyageReservationsRepository: MockVoyageReservationsRepository!
    private var useCase: GetVoyageReservationsUseCase!
    
    override func setUp() {
        super.setUp()
        mockVoyageReservationsRepository = MockVoyageReservationsRepository()
        useCase = GetVoyageReservationsUseCase(
            voyageReservations: mockVoyageReservationsRepository
        )
    }
    
    override func tearDown() {
        mockVoyageReservationsRepository = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        let mockVoyageReservations = VoyageReservations.sample()
        
        mockVoyageReservationsRepository.voyageReservations = mockVoyageReservations
        
        let result = try await useCase.execute()
            
        XCTAssertEqual(result.profilePhotoURL, mockVoyageReservations.profilePhotoURL)
        XCTAssertEqual(result.pageDetails.title, mockVoyageReservations.pageDetails.title)
        XCTAssertEqual(result.pageDetails.description, mockVoyageReservations.pageDetails.description)
        XCTAssertEqual(result.pageDetails.imageURL, mockVoyageReservations.pageDetails.imageURL)
        XCTAssertEqual(result.guestBookings.count, mockVoyageReservations.guestBookings.count)
    }
    
    func testExecute_Error() async {
        mockVoyageReservationsRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute(useCache: true)
            XCTFail("Expected an error but did not receive one.")
        } catch {
            XCTAssertTrue(error is VVDomainError)
        }
    }
}
