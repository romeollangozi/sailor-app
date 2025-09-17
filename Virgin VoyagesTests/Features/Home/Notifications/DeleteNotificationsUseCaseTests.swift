//
//  DeleteNotificationsUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 1.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class DeleteAllNotificationsUseCaseTests: XCTestCase {
    private var mockRepository: MockDeleteAllNotificationsRepository!
    private var mockCurrentSailorManager: MockCurrentSailorManager!
    private var useCase: DeleteAllNotificationsUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockDeleteAllNotificationsRepository()
        mockCurrentSailorManager = MockCurrentSailorManager()
        useCase = DeleteAllNotificationsUseCase(
            currentSailorManager: mockCurrentSailorManager,
            deleteAllNotificationsRepository: mockRepository
        )
    }
    
    override func tearDown() {
        mockRepository = nil
        mockCurrentSailorManager = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        let sampleSailor = CurrentSailor.sample()
        let sampleResponse = EmptyResponse()
        
        mockCurrentSailorManager.lastSailor = sampleSailor
        mockRepository.response = sampleResponse
        
        let result = try await useCase.execute()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(mockRepository.passedReservationGuestId, sampleSailor.reservationGuestId)
        XCTAssertEqual(mockRepository.passedVoyageNumber, sampleSailor.voyageNumber)
    }
    
    func testExecute_ReturnsNil_ThrowsError() async {
        mockRepository.shouldReturnNil = true
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? VVDomainError, VVDomainError.genericError)
        }
    }
}
