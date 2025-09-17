//
//  GetHomeComingGuideUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 4.4.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetHomeComingGuideUseCaseTests: XCTestCase {

    var useCase: GetHomeComingGuideUseCase!
    var mockSailorManager: MockCurrentSailorManager!
    var mockRepository: MockGetHomeComingGuideRepository!

    override func setUp() {
        super.setUp()
        mockSailorManager = MockCurrentSailorManager()
        mockRepository = MockGetHomeComingGuideRepository()
        useCase = GetHomeComingGuideUseCase(repository: mockRepository, currentSailorManager: mockSailorManager)
    }

    override func tearDown() {
        useCase = nil
        mockSailorManager = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_Success() async throws {
        let mockResponse = HomeComingGuide.sample()
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
	final class MockGetHomeComingGuideRepository: HomeComingGuideRepositoryProtocol {
        var mockResponse: HomeComingGuide?
        var shouldThrowError = false

		func getHomeComingGuide(reservationGuestId: String, reservationId: String, debarkDate: String, shipCode: String, voyageNumber: String) async throws -> HomeComingGuide? {
            if shouldThrowError {
                throw VVDomainError.genericError
            }
            return mockResponse
        }
    }
}

