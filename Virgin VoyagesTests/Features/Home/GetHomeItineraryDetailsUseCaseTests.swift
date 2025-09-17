//
//  GetHomeItineraryDetailsUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 7.4.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetHomeItineraryDetailsUseCaseTests: XCTestCase {

    var useCase: GetHomeItineraryDetailsUseCase!
    var mockSailorManager: MockCurrentSailorManager!
    var mockRepository: MockGetHomeItineraryDetailsRepository!

    override func setUp() {
        super.setUp()
        mockSailorManager = MockCurrentSailorManager()
        mockRepository = MockGetHomeItineraryDetailsRepository()
        useCase = GetHomeItineraryDetailsUseCase(repository: mockRepository, currentSailorManager: mockSailorManager)
    }

    override func tearDown() {
        useCase = nil
        mockSailorManager = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_Success() async throws {
        let mockResponse = HomeItineraryDetails.sample()
        mockRepository.mockResponse = mockResponse
        mockRepository.shouldThrowError = false

        let result = try await useCase.execute()

        XCTAssertEqual(result, mockResponse)
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

    // MARK: - Mocks
    final class MockGetHomeItineraryDetailsRepository: HomeItineraryDetailsRepositoryProtocol {
        var mockResponse: HomeItineraryDetails?
        var shouldThrowError = false

        func getItineraryDetails(reservationGuestId: String, voyageNumber: String, reservationNumber: String) async throws -> HomeItineraryDetails? {
            if shouldThrowError {
                throw VVDomainError.genericError
            }
            return mockResponse
        }
    }
}
