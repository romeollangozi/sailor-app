//
//  GetSailorProfileV2UseCaseTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 27.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetSailorProfileV2UseCaseTests: XCTestCase {
    
    var useCase: GetSailorProfileV2UseCasePotocol!
    var sailorProfileRepositoryMock: SailorProfileV2RepositoryMock!
    var mockSailorManager: MockCurrentSailorManager!

    override func setUp() {
        super.setUp()
        sailorProfileRepositoryMock = SailorProfileV2RepositoryMock()
        useCase = GetSailorProfileV2UseCase(sailorsProfileRepository: sailorProfileRepositoryMock)
    }

    override func tearDown() {
        useCase = nil
        sailorProfileRepositoryMock = nil
        super.tearDown()
    }

    func testExecuteReturnstSailorProfile() async throws {
        let mockSailorPtofile = SailorProfileV2.sample()
        sailorProfileRepositoryMock.mockSailorProfile = mockSailorPtofile
        
        let result = try await useCase.execute(reservationNumber: nil)
        XCTAssertEqual(result, mockSailorPtofile)
    }
}
