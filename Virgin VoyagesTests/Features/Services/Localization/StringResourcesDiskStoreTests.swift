//
//  StringResourcesDiskStoreTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 16.6.25.
//

import XCTest
@testable import Virgin_Voyages

final class StringResourcesDiskStoreTests: XCTestCase {
    var diskStore: StringResourcesDiskStore!
    let testKey = "test.key"

    override func setUp() {
        super.setUp()
        diskStore = StringResourcesDiskStore(fileName: "test_translations.json")
        try? FileManager.default.removeItem(at: diskStore.testableFileURL())
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: diskStore.testableFileURL())
    }

    func test_saveAndLoadTranslations() throws {
        let translations = [testKey: "Test Value"]
        try diskStore.save(translations)

        let loaded = try diskStore.load()
        XCTAssertEqual(loaded[testKey], "Test Value")
    }

    func test_fileExists_trueAfterSave() throws {
        XCTAssertFalse(diskStore.fileExists())
        try diskStore.save([testKey: "value"])
        XCTAssertTrue(diskStore.fileExists())
    }
}

private extension StringResourcesDiskStore {
    func testableFileURL() -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent("test_translations.json")
    }
}
