//
//  DeleteDocumentUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 21.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class DeleteDocumentUseCaseTests: XCTestCase {
    var useCase: DeleteDocumentUseCase!
    var mockSailorManager: MockRtsCurrentSailorManager!
    var mockRepository: MockDeleteDocumentRepository!

    override func setUp() {
        super.setUp()
        mockSailorManager = MockRtsCurrentSailorManager()
        mockRepository = MockDeleteDocumentRepository()
        useCase = DeleteDocumentUseCase(
            currentSailorManager: mockSailorManager,
            deleteDocumentRepository: mockRepository
        )
    }

    override func tearDown() {
        useCase = nil
        mockSailorManager = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_Success() async throws {
        let expectedDocument = DeletedDocument.sample()
        mockRepository.mockResponse = expectedDocument
        mockRepository.shouldThrowError = false

        let sampleInput = DeleteDocumentInput.sample()

        let result = try await useCase.execute(input: sampleInput)

        XCTAssertEqual(result, expectedDocument)
    }

    func testExecute_Error() async {
        mockRepository.shouldThrowError = true

        let sampleInput = DeleteDocumentInput.sample()

        do {
            _ = try await useCase.execute(input: sampleInput)
            XCTFail("Expected an error but got a result")
        } catch {
            XCTAssertTrue(error is VVDomainError)
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }

    func testExecute_NoData() async {
        mockRepository.mockResponse = nil

        let sampleInput = DeleteDocumentInput.sample()

        do {
            _ = try await useCase.execute(input: sampleInput)
            XCTFail("Expected a generic error but got a result")
        } catch {
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }
}

// MARK: - Mocks
final class MockDeleteDocumentRepository: DeleteDocumentRepositoryProtocol {
    var mockResponse: DeletedDocument?
    var shouldThrowError = false

    func deleteDocument(reservationGuestId: String, input: DeleteDocumentInput) async throws -> DeletedDocument? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return mockResponse
    }
}
