//
//  MockBookingReservationService.swift
//  Virgin Voyages
//
//  Created by TX on 15.4.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockBookingReservationService: BookingReservationServiceProtocol {
    var mockDetails = ReservationDetails(
        reservationGuestId: "GUEST456",
        reservationNumber: "ABC123",
        voyageNumber: "1234",
        shipCode: "VV01"
    )

    func getCurrentReservationDetails() throws -> ReservationDetails {
        return mockDetails
    }
}
