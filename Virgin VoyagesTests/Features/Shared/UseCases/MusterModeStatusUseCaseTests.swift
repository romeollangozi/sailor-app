//
//  MusterModeStatusUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 25.8.25.
//

import XCTest
@testable import Virgin_Voyages

final class MusterModeStatusUseCaseTests: XCTestCase {

    func testGetMusterModeStatus() {
        let mockRepository = MockMusterModeStatusRepository(musterDrillMode: .important)
        let useCase = MusterModeStatusUseCase(repository: mockRepository)
        let result = useCase.getMusterMode()

        XCTAssertEqual(result, .important)
        XCTAssertTrue(mockRepository.didFetch)
    }

    func testUpdateMusterModeStatus() throws {
        let mockRepository = MockMusterModeStatusRepository(musterDrillMode: .important)
        let useCase = MusterModeStatusUseCase(repository: mockRepository)
        try useCase.updateMusterMode(.info)

        XCTAssertEqual(mockRepository.updateCalledWith, .info)
    }

}
