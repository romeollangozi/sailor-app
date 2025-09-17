//
//  GetFolioUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 16.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetFolioUseCaseTests: XCTestCase {
    private var mockFolioRepository: MockFolioRepository!
    private var mockMyVoyageRepository: MockMyVoyageRepository!
    private var mockCurrentSailorManager: MockCurrentSailorManager!
    private var useCase: GetFolioUseCase!

    override func setUp() {
        super.setUp()
        mockFolioRepository = MockFolioRepository()
        mockMyVoyageRepository = MockMyVoyageRepository()
        mockCurrentSailorManager = MockCurrentSailorManager()
        useCase = GetFolioUseCase(
            folioRepository: mockFolioRepository,
            myVoyageRepository: mockMyVoyageRepository,
            currentSailorManager: mockCurrentSailorManager
        )
    }

    override func tearDown() {
        mockFolioRepository = nil
        mockMyVoyageRepository = nil
        mockCurrentSailorManager = nil
        useCase = nil
        super.tearDown()
    }

    func testExecute_Success() async throws {
        let expectedFolio = Folio.sample()
        mockFolioRepository.mockFolio = expectedFolio
		mockMyVoyageRepository.mockSailingMode = .postCruise
        let mockSailor = CurrentSailor.sample()
        mockCurrentSailorManager.lastSailor = mockSailor
        let result = try await useCase.execute()

        XCTAssertEqual(result, expectedFolio)
    }

    func testExecute_Throws_WhenFolioIsNil() async {
        mockFolioRepository.mockFolio = nil

        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error, but got success")
        } catch {
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }

    func testExecute_Throws_WhenRepositoryThrows() async {
        mockFolioRepository.shouldThrowError = true

        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error, but got success")
        } catch {
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }
}
