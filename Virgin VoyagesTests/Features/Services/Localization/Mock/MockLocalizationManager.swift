//
//  MockLocalizationManager.swift
//  Virgin Voyages
//
//  Created by TX on 16.6.25.
//
import XCTest
@testable import Virgin_Voyages

class MockLocalizationManager: LocalizationManagerProtocol {
    private(set) var applied: [String: String] = [:]
    private(set) var loadedDefaults = false

    private var localizedStrings: [String: String] = [:]
    private var initialDefaults: [String: String] = [:]

    init(preloaded: [LocalizedStringKey: String] = [:]) {
        let flat = Dictionary(uniqueKeysWithValues: preloaded.map { ($0.key.key, $0.value) })
        self.localizedStrings = flat
        self.initialDefaults = flat 
    }

    func setCustomTranslations(_ messages: [String: String]) {
        applied = messages
        localizedStrings.merge(messages) { _, new in new }
    }

    func loadDefaults() {
        loadedDefaults = true
        localizedStrings = initialDefaults
    }

    func setString(_ string: String, for key: LocalizedStringKey) {
        localizedStrings[key.key] = string
    }

    func getString(for key: LocalizedStringKey) -> String {
        return localizedStrings[key.key] ?? ""
    }

    func getString(for key: LocalizedStringKey, with parameters: [String: String]) -> String {
        let template = getString(for: key)
        return parameters.reduce(template) { result, entry in
            result.replacingOccurrences(of: "{\(entry.key)}", with: entry.value)
        }
    }
}
