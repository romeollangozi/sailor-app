//
//  MockDownloadFolioInvoiceUseCase.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 18.7.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockDownloadFolioInvoiceUseCase: DownloadFolioInvoiceUseCaseProtocol {
    var expectedData: Data = "Mock PDF Data".data(using: .utf8)!
    var shouldThrowError: Bool = false

    func execute() async throws -> Data {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return expectedData
    }
}
