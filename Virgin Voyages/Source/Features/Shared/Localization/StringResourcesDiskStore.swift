//
//  StringResourcesDiskStore.swift
//  Virgin Voyages
//
//  Created by TX on 16.6.25.
//
import Foundation

protocol StringResourcesDiskStoreProtocol {
    func save(_ translations: [String: String]) throws
    func load() throws -> [String: String]
    func fileExists() -> Bool
}

class StringResourcesDiskStore: StringResourcesDiskStoreProtocol {
    private let fileURL: URL

    init(fileName: String = "translations.json") {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = directory.appendingPathComponent(fileName)
    }

    func save(_ translations: [String: String]) throws {
        let data = try JSONEncoder().encode(translations)
        try data.write(to: fileURL)
    }

    func load() throws -> [String: String] {
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([String: String].self, from: data)
    }

    func fileExists() -> Bool {
        FileManager.default.fileExists(atPath: fileURL.path)
    }
}
