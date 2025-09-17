//
//  GetTravelDocumentsUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 25.2.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetTravelDocumentsUseCaseTests: XCTestCase {
    var useCase: GetTravelDocumentsUseCase!
    var mockSailorManager: MockRtsCurrentSailorManager!
    var mockRepository: MockTravelDocumentsRepository!

    override func setUp() {
        super.setUp()
        mockSailorManager = MockRtsCurrentSailorManager()
        mockRepository = MockTravelDocumentsRepository()
        useCase = GetTravelDocumentsUseCase(
            currentSailorManager: mockSailorManager,
            travelDocumentsRepository: mockRepository
        )
    }

    override func tearDown() {
        useCase = nil
        mockSailorManager = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_Success() async throws {
        let mockDocuments = TravelDocuments.sample()
        mockRepository.mockResponse = mockDocuments
        mockRepository.shouldThrowError = false

        let result = try await useCase.execute()

        XCTAssertEqual(result, mockDocuments)
    }

    func testExecute_Error() async {
        mockRepository.shouldThrowError = true

        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error but got a result")
        } catch {
            XCTAssertTrue(error is VVDomainError)
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }

    func testExecute_NoData() async {
        mockRepository.mockResponse = nil

        do {
            _ = try await useCase.execute()
            XCTFail("Expected a notFound error but got a result")
        } catch {
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }
}

// MARK: - Mocks
final class MockTravelDocumentsRepository: TravelDocumentsRepositoryProtocol {
    var mockResponse: TravelDocuments?
    var shouldThrowError = false

    func fetchTravelDocuments(reservationGuestId: String) async throws -> TravelDocuments? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return mockResponse
    }
}
