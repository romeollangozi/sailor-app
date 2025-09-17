//
//  MockReservationsRepository.swift
//  Virgin Voyages
//
//  Created by TX on 27.8.25.
//

import XCTest
@testable import Virgin_Voyages

final class MockReservationsRepository: ReservationsRepositoryProtocol {
    var sailorReservations: SailorReservations?
    var reservationSummaryByNumber: [String: SailorReservationSummary] = [:]

    func fetchSailorReservations() async throws -> SailorReservations? {
        sailorReservations
    }

    func fetchSailorReservationSummary(reservationNumber: String) async throws -> SailorReservationSummary? {
        reservationSummaryByNumber[reservationNumber]
    }
}
