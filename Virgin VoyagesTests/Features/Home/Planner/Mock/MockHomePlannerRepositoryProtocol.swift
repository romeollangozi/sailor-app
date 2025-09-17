//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 23.3.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockHomePlannerRepository: HomePlannerRepositoryProtocol {
    var homePlanner: HomePlannerSection?
    var shouldThrowError = false
    
    func fetchHomePlanner(reservationGuestId: String, reservationNumber: String, shipCode: String, voyageNumber: String) async throws -> HomePlannerSection? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return homePlanner ?? HomePlannerSection.empty()
    }
}
