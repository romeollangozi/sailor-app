//
//  MockVoyageReservationsRepository.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 3.6.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockVoyageReservationsRepository: VoyageReservationsRepositoryProtocol {
  
    var voyageReservations: VoyageReservations?
    var shouldThrowError = false

    func fetchVoyageReservations() async throws -> VoyageReservations? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return voyageReservations
    }
}
