//
//  LocalizationManagerTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 16.6.25.
//

import XCTest
@testable import Virgin_Voyages

final class LocalizationManagerTests: XCTestCase {

    private var manager: MockLocalizationManager!

    override func setUp() {
        super.setUp()
        manager = MockLocalizationManager(preloaded: [
            .messengerScreenTitle: "Messenger",
            .messengerTryAgainText: "Try again",
            .bookingsReopenOnBoard: "Reopens on {shipName}"
        ])
    }

    override func tearDown() {
        manager = nil
        super.tearDown()
    }

    // MARK: - Default fallback

    func test_defaultTranslation_isReturned_whenNoCustomExists() {
        let value = manager.getString(for: .messengerScreenTitle)
        XCTAssertEqual(value, "Messenger")
    }

    func test_missingTranslation_returnsEmptyString() {
        let value = manager.getString(for: .messengerContactsEmptyState)
        XCTAssertEqual(value, "")
    }

    // MARK: - Custom override

    func test_customTranslationOverridesDefault() {
        manager.setCustomTranslations([
            "global.messagesText": "Custom Messenger"
        ])
        let value = manager.getString(for: .messengerScreenTitle)
        XCTAssertEqual(value, "Custom Messenger")
    }

    // MARK: - Template substitution

    func test_templateString_substitutesParameter() {
        let result = manager.getString(for: .bookingsReopenOnBoard, with: ["shipName": "Scarlet Lady"])
        XCTAssertEqual(result, "Reopens on Scarlet Lady")
    }

    func test_templateString_missingParameter_leavesPlaceholder() {
        let result = manager.getString(for: .bookingsReopenOnBoard, with: [:])
        XCTAssertEqual(result, "Reopens on {shipName}")
    }

    // MARK: - Reset / fallback to defaults

    func test_loadDefaults_resetsToEmptyCustoms() {
        manager.setCustomTranslations([
            "global.messagesText": "Custom Messenger"
        ])
        manager.loadDefaults()
        let value = manager.getString(for: .messengerScreenTitle)
        XCTAssertEqual(value, "Messenger") // original preloaded default
    }
}
