//
//  GetPostVoyagePlansUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 25.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetPostVoyagePlansUseCaseTests: XCTestCase {
    var useCase: GetPostVoyagePlansUseCase!
    var mockSailorManager: MockRtsCurrentSailorManager!
    var mockRepository: MockGetPostVoyagePlansRepository!

    override func setUp() {
        super.setUp()
        mockSailorManager = MockRtsCurrentSailorManager()
        mockRepository = MockGetPostVoyagePlansRepository()
        useCase = GetPostVoyagePlansUseCase(
            currentSailorManager: mockSailorManager,
            getPostVoyagePlansRepository: mockRepository
        )
    }

    override func tearDown() {
        useCase = nil
        mockSailorManager = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_Success() async throws {
        let mockPlans = PostVoyagePlans.sample()
        mockRepository.mockResponse = mockPlans
        mockRepository.shouldThrowError = false

        let result = try await useCase.execute()

        XCTAssertEqual(result, mockPlans)
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

final class MockGetPostVoyagePlansRepository: GetPostVoyagePlansRepositoryProtocol {
    var mockResponse: PostVoyagePlans?
    var shouldThrowError = false

    func getPostVoyagePlans(reservationGuestId: String) async throws -> PostVoyagePlans? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return mockResponse
    }
}
