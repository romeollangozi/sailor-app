//
//  ScanTravelDocumentUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 4.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class ScanTravelDocumentUseCaseTests: XCTestCase {
    var useCase: ScanTravelDocumentUseCase!
    var mockSailorManager: MockRtsCurrentSailorManager!
    var mockRepository: MockTravelDocumentDetailsRepository!

    override func setUp() {
        super.setUp()
        mockSailorManager = MockRtsCurrentSailorManager()
        mockRepository = MockTravelDocumentDetailsRepository()
        useCase = ScanTravelDocumentUseCase(
            currentSailorManager: mockSailorManager,
            scanTravelDocumentRepository: mockRepository
        )
    }

    override func tearDown() {
        useCase = nil
        mockSailorManager = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_Success() async throws {
        let mockDocument = TravelDocumentDetails.sample()
        mockRepository.mockResponse = mockDocument
        mockRepository.shouldThrowError = false
        let input = ScanTravelDocumentInputModel(documentCode: "V", categoryCode: "", documentType: "VISA", ocrValidation: true, photoContent: nil, documentPhotoId: nil, documentBackPhotoId: nil, id: "12345")

        let result = try await useCase.execute(input: input)

        XCTAssertEqual(result, mockDocument)
    }

    func testExecute_Error() async {
        mockRepository.shouldThrowError = true

        do {
            _ = try await useCase.execute(input: ScanTravelDocumentInputModel.empty())
            XCTFail("Expected an error but got a result")
        } catch {
            XCTAssertTrue(error is VVDomainError)
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }

    func testExecute_NoData() async {
        mockRepository.mockResponse = nil

        do {
            _ = try await useCase.execute(input: ScanTravelDocumentInputModel.empty())
            XCTFail("Expected a notFound error but got a result")
        } catch {
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }
}

// MARK: - Mocks
final class MockTravelDocumentDetailsRepository: ScanTravelDocumentRepositoryProtocol {
    var mockResponse: TravelDocumentDetails?
    var shouldThrowError = false

    func scanTravelDocument(input: ScanTravelDocumentInput) async throws -> TravelDocumentDetails? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return mockResponse
    }
}
