//
//  DownloadFolioInvoiceUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 18.7.25.
//

import XCTest
@testable import Virgin_Voyages

final class DownloadFolioInvoiceUseCaseTests: XCTestCase {
    
    private var mockRepository: MockDownloadFolioInvoiceRepository!
    private var mockCurrentSailorManager: MockCurrentSailorManager!
    private var useCase: DownloadFolioInvoiceUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockDownloadFolioInvoiceRepository()
        mockCurrentSailorManager = MockCurrentSailorManager()
        useCase = DownloadFolioInvoiceUseCase(
            downloadFolioInvoiceRepository: mockRepository,
            currentSailorManager: mockCurrentSailorManager
        )
    }

    override func tearDown() {
        mockRepository = nil
        mockCurrentSailorManager = nil
        useCase = nil
        super.tearDown()
    }

    // MARK: - Tests
    
    func testDownloadOnSuccessData() async throws {
        let mockSailor = CurrentSailor.sample()
        mockCurrentSailorManager.lastSailor = mockSailor

        let expectedData = "Test PDF".data(using: .utf8)!
        mockRepository.expectedData = expectedData

        let result = try await useCase.execute()
        XCTAssertEqual(result, expectedData)
    }
    
    func test_execute_whenRepositoryReturnsNil_throwsGenericError() async {
        mockCurrentSailorManager.lastSailor = CurrentSailor.sample()
        mockRepository.expectedData = nil

        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error, but got success")
        } catch {
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }
}
