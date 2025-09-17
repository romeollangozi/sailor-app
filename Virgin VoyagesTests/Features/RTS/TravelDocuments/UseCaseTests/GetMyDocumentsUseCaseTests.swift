//
//  GetMyDocumentsUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 19.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetMyDocumentsUseCaseTests: XCTestCase {
    var useCase: GetMyDocumentsUseCase!
    var mockSailorManager: MockRtsCurrentSailorManager!
    var mockRepository: MockGetMyDocumentsRepository!

    override func setUp() {
        super.setUp()
        mockSailorManager = MockRtsCurrentSailorManager()
        mockRepository = MockGetMyDocumentsRepository()
        useCase = GetMyDocumentsUseCase(currentSailorManager: mockSailorManager, getMyDocumentsRepository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockSailorManager = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_Success() async throws {
        let mockMyDocuments = MyDocuments.sample()
        mockRepository.mockResponse = mockMyDocuments
        mockRepository.shouldThrowError = false

        let result = try await useCase.execute()

        XCTAssertEqual(result, mockMyDocuments)
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
}

// MARK: - Mocks
final class MockGetMyDocumentsRepository: GetMyDocumentsRepositoryProtocol {
    var mockResponse: MyDocuments?
    var shouldThrowError = false

    func getMyDocuments(reservationGuestId: String) async throws -> MyDocuments? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return mockResponse
    }
}
