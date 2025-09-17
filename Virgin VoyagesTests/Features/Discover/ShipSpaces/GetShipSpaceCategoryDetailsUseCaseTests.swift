//
//  GetShipSpaceCategoryDetailsUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 5.2.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetShipSpaceCategoryDetailsUseCaseTests: XCTestCase {
    var useCase: GetShipSpaceCategoryDetailsUseCase!
    var mockRepository: MockGetShipSpaceCategoryDetailsRepository!
    var mockSailorManager: MockCurrentSailorManager!

    override func setUp() {
        super.setUp()
        mockRepository = MockGetShipSpaceCategoryDetailsRepository()
        mockSailorManager = MockCurrentSailorManager()
        useCase = GetShipSpaceCategoryDetailsUseCase(currentSailorManager: mockSailorManager, repository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        mockSailorManager = nil
        super.tearDown()
    }

    func testExecute_Success() async throws {
        // Arrange
        let mockCategoryDetails = ShipSpaceCategoryDetails.sample()
        mockRepository.mockResponse = mockCategoryDetails
        mockRepository.shouldThrowError = false

        // Act
        let result = try await useCase.execute(shipSpaceCategoryCode: "TestCategory")

        // Assert
        XCTAssertEqual(result, mockCategoryDetails)
    }

    func testExecute_Error() async {
        // Arrange
        mockRepository.shouldThrowError = true

        // Act & Assert
        do {
            _ = try await useCase.execute(shipSpaceCategoryCode: "TestCategory")
            XCTFail("Expected an error but got a result")
        } catch {
            XCTAssertTrue(error is VVDomainError)
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }

    func testExecute_NoData() async {
        // Arrange
        mockRepository.mockResponse = nil

        // Act & Assert
        do {
            _ = try await useCase.execute(shipSpaceCategoryCode: "TestCategory")
            XCTFail("Expected a notFound error but got a result")
        } catch {
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }
}

// MARK: - Mocks
final class MockGetShipSpaceCategoryDetailsRepository: GetShipSpaceCategoryDetailsRepositoryProtocol {
    var mockResponse: ShipSpaceCategoryDetails?
    var shouldThrowError = false

    var lastGuestId: String?
    var lastShipCode: String?

    func fetchShipSpaceCategoryDetails(shipSpaceCategoryCode: String, guestId: String, shipCode: String, useCache: Bool) async throws -> ShipSpaceCategoryDetails? {
        lastGuestId = guestId
        lastShipCode = shipCode

        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return mockResponse
    }
}
