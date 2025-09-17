//
//  MockEateriesOpeningTimesRepository.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 23.6.25.
//

import XCTest
@testable import Virgin_Voyages

final class MockEateriesOpeningTimesRepository: EateriesOpeningTimesRepositoryProtocol {
    var mockResponse: EateriesOpeningTimes?
    var shouldThrowError: Bool = false

    func fetchEateriesOpeningTimes(
        reservationId: String,
        reservationGuestId: String,
        shipCode: String,
        reservationNumber: String,
        selectedDate: String
    ) async throws -> EateriesOpeningTimes? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return mockResponse
    }
}

