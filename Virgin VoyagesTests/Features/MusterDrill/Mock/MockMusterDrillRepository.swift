//
//  MockMusterDrillRepository.swift
//  Virgin VoyagesTests
//
//  Created by TX on 10.4.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockMusterDrillRepository: MusterDrillRepositoryProtocol {
    var mockResponse: MusterDrillContent?
    var markCalled: Bool = false
    var calledShipCode: String?
    var calledCabinNumber: String?
    var calledReservationGuestId: String?
    var shouldThrow = false

    func fetchMusterDrillContent(shipcode: String, guestId: String) async throws -> MusterDrillContent? {
        return mockResponse
    }
    
    func markVideoWatched(shipcode: String, cabinNumber: String, reservationGuestId: String) async throws {
        if shouldThrow {
            throw VVDomainError.genericError
        }
        markCalled = true
        calledShipCode = shipcode
        calledCabinNumber = cabinNumber
        calledReservationGuestId = reservationGuestId
    }

}

