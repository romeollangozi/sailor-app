//
//  GetShipSpacesCategoriesUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 30.1.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetShipSpacesCategoriesUseCaseTests: XCTestCase {
    var useCase: GetShipSpacesCategoriesUseCase!
    var mockSailorManager: MockCurrentSailorManager!
    var mockRepository: MockGetShipSpacesRepository!

    override func setUp() {
        super.setUp()
        mockSailorManager = MockCurrentSailorManager()
        mockRepository = MockGetShipSpacesRepository()
        useCase = GetShipSpacesCategoriesUseCase(currentSailorManager: mockSailorManager, shipSpacesRepository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockSailorManager = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_Success() async throws {
        let mockShipSpaces = ShipSpacesCategories.sample()
        mockRepository.mockResponse = mockShipSpaces
        mockRepository.shouldThrowError = false

        let result = try await useCase.execute()

        XCTAssertEqual(result, mockShipSpaces)
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
final class MockGetShipSpacesRepository: GetShipSpacesCategoriesRepositoryProtocol {
    var mockResponse: ShipSpacesCategories?
    var shouldThrowError = false

    func fetchShipSpaces(reservationId: String, guestId: String, shipCode: String, useCache: Bool) async throws -> ShipSpacesCategories? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return mockResponse
    }
}
