//
//  MockHTMLFetcherService.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 10.9.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockHTMLFetcherService: HTMLFetcherServiceProtocol {
    var htmlByURL: [String: String?] = [:]
    private(set) var calledURLs: [String] = []

    func fetchHTML(from urlString: String) async -> String? {
        calledURLs.append(urlString)
        return htmlByURL[urlString] ?? nil
    }
}
