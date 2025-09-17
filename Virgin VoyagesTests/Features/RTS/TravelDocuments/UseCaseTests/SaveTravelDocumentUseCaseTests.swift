//
//  SaveTravelDocumentUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 12.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class SaveTravelDocumentUseCaseTests: XCTestCase {
    var useCase: SaveTravelDocumentUseCase!
    var rtsCurrentSailorService: MockRtsCurrentSailorManager!
    var mockRepository: MockSaveTravelDocumentRepository!
	var mockCurrentSailorManager: MockCurrentSailorManager!

    override func setUp() {
        super.setUp()
		rtsCurrentSailorService = MockRtsCurrentSailorManager()
		mockRepository = MockSaveTravelDocumentRepository()
		mockCurrentSailorManager = MockCurrentSailorManager()
		
        useCase = SaveTravelDocumentUseCase(
			rtsCurrentSailorService: rtsCurrentSailorService,
			saveTravelDocumentRepository: mockRepository,
            currentSailorManager: mockCurrentSailorManager
        )
    }

    override func tearDown() {
        useCase = nil
		rtsCurrentSailorService = nil
        mockRepository = nil
		mockCurrentSailorManager = nil
        super.tearDown()
    }
}

// MARK: - Mocks
final class MockSaveTravelDocumentRepository: SaveTravelDocumentRepositoryProtocol {
	
    var mockResponse: SavedTravelDocument?
    var shouldThrowError = false
    var validationError: ValidationError?

    func saveTravelDocument(input: SaveTravelDocumentInput) async throws -> SavedTravelDocument? {
        if shouldThrowError, let validationError = validationError {
            throw VVDomainError.validationError(error: validationError)
        }
        
        return mockResponse
    }

        func saveTravelDocument(reservationGuestId: String, id: String, embarkDate: String, debarkDate: String, input: SaveTravelDocumentInput) async throws -> Virgin_Voyages.SavedTravelDocument? {
            if shouldThrowError, let validationError = validationError {
                throw VVDomainError.validationError(error: validationError)
            }
            
            return mockResponse        }
    
}
