//
//  HTMLFetcherService.swift
//  Virgin Voyages
//
//  Created by Pajtim on 10.9.25.
//

import Foundation

protocol HTMLFetcherServiceProtocol {
    func fetchHTML(from urlString: String) async -> String?
}

final class HTMLFetcherService: HTMLFetcherServiceProtocol {
    func fetchHTML(from urlString: String) async -> String? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Failed to fetch HTML: \(error)")
            return nil
        }
    }
}
