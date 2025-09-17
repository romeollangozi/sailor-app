//
//  VoyageSelectionScreenViewModelMocks.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 3.6.25.
//

import XCTest
@testable import Virgin_Voyages

// MARK: - Mocks

class MockGetVoyageReservationsUseCase: GetVoyageReservationsUseCaseProtocol {
    var executeResult: VoyageReservations?
    var lastUseCacheValue: Bool?

    func execute(useCache: Bool) async throws -> VoyageReservations {
        lastUseCacheValue = useCache
        return executeResult ?? VoyageReservations.empty()
    }
}

