//
//  LoadLocalizationUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 16.6.25.
//

import Foundation
import XCTest
@testable import Virgin_Voyages

final class LoadLocalizationUseCaseTests: XCTestCase {

    func test_successfulNetworkLoad_savesToDisk_andSetsManager() async {
        let repo = MockRepository()
        repo.returnedTranslations = ["abc": "def"]

        let disk = MockDiskStore()
        let manager = MockLocalizationManager()

        let useCase = LoadLocalizationUseCase(repository: repo, diskStore: disk, localizationManager: manager)
        await useCase.execute(useCache: false)

        XCTAssertEqual(manager.applied["abc"], "def")
        XCTAssertEqual(disk.stored["abc"], "def")
    }

    func test_networkFails_loadsFromDisk() async {
        let repo = MockRepository()
        repo.shouldFail = true

        let disk = MockDiskStore()
        disk.hasFile = true
        disk.stored = ["x": "y"]

        let manager = MockLocalizationManager()
        let useCase = LoadLocalizationUseCase(repository: repo, diskStore: disk, localizationManager: manager)

        await useCase.execute(useCache: true)
        XCTAssertEqual(manager.applied["x"], "y")
    }

    func test_networkFailsAndNoDisk_loadsDefaults() async {
        let repo = MockRepository()
        repo.shouldFail = true

        let disk = MockDiskStore()
        disk.hasFile = false

        let manager = MockLocalizationManager()
        let useCase = LoadLocalizationUseCase(repository: repo, diskStore: disk, localizationManager: manager)

        await useCase.execute(useCache: true)
        XCTAssertTrue(manager.loadedDefaults)
    }
}
