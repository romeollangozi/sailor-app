//
//  GetLookupUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 17.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetLookupUseCaseTests: XCTestCase {
    var useCase: GetLookupUseCase!
    var mockRepository: MockGetLookupRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockGetLookupRepository()
        useCase = GetLookupUseCase(lookupRepository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_Success() async throws {
        let mockLookup = Lookup.sample()
        mockRepository.mockResponse = mockLookup
        mockRepository.shouldThrowError = false

        let result = try await useCase.execute()

        XCTAssertEqual(result, mockLookup)
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
            XCTFail("Expected a genericError but got a result")
        } catch {
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }
}

final class MockGetLookupRepository: GetLookupRepositoryProtocol {
    var mockResponse: Lookup?
    var shouldThrowError = false

	func fetchLookupData(useCache: Bool) async throws -> Lookup? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return mockResponse
    }
}
