//
//  FolioViewModelTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 13.6.25.
//

import XCTest
@testable import Virgin_Voyages

@MainActor
final class FolioViewModelTests: XCTestCase {

    var sut: FolioScreenViewModel!

    // MARK: - Mock Dependencies
    var mockGetFolioUseCase : MockGetFolioUseCase!
    var mockGetSailingModeUseCase: MockGetSailingModeUseCase!

    override func setUp() {
        super.setUp()
        mockGetFolioUseCase = MockGetFolioUseCase()
        mockGetSailingModeUseCase = MockGetSailingModeUseCase()
       
        sut = FolioScreenViewModel(getFolioUseCase: mockGetFolioUseCase, getSailingModeUseCase: mockGetSailingModeUseCase)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_onAppear() {
        mockGetFolioUseCase.executeResult = .sample()

        executeAndWaitForAsyncOperation { [self] in
            Task { sut.onAppear() }
        }

        XCTAssertNotNil(sut.folio.preCruise)
        XCTAssertEqual(sut.folio.preCruise?.header, "My Wallet")
        XCTAssertNotNil(sut.folio.shipboard)
        XCTAssertEqual(sut.folio.shipboard?.dependent?.name, "Liam Doe")
        XCTAssertEqual(sut.folio.shipboard?.wallet?.header?.barTabRemaining?.items.count, 2)
        XCTAssertEqual(sut.folio.shipboard?.wallet?.sailorLoot?.title, "SAILOR LOOT: Pending")
        XCTAssertEqual(sut.folio.shipboard?.wallet?.transactions.count, 1)
    }
}
