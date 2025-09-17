//
//  MockFolioRepository.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 16.5.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockFolioRepository: FolioRepositoryProtocol {

    var mockFolio: Folio?
    var shouldThrowError = false

    func fetchFolio(sailingMode: SailingMode, reservationGuestId: String, reservationId: String) async throws -> Folio? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return mockFolio
    }
}
