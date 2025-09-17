//
//  ReservationsRepositoryProtocolMock.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 14.11.24.
//

import Foundation
@testable import Virgin_Voyages

class ReservationsRepositoryProtocolMock: ReservationsRepositoryProtocol {
    var fetchSailorReservationsReturnValue: SailorReservations?
    var fetchSailorReservationsThrowableError: Error?
    
    var fetchSailorReservationSummaryReturnValue: SailorReservationSummary?
    var fetchSailorReservationSummaryThrowableError: Error?
    
    func fetchSailorReservations() async throws -> SailorReservations? {
        if let error = fetchSailorReservationsThrowableError {
            throw error
        }
        return fetchSailorReservationsReturnValue
    }
    
    func fetchSailorReservationSummary(reservationNumber: String) async throws -> SailorReservationSummary? {
        if let error = fetchSailorReservationSummaryThrowableError {
            throw error
        }
        return fetchSailorReservationSummaryReturnValue
    }
}
