//
//  MockRTS.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 29.4.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockRtsCurrentSailorManager: RtsCurrentSailorProtocol {
    private var sailor: RtsCurrentSailor = RtsCurrentSailor(reservationGuestId: "mockReservationGuestId")

    func getCurrentSailor() -> RtsCurrentSailor {
        return sailor
    }

    @discardableResult
    func setSailor(sailor: RtsCurrentSailor) -> Bool {
        self.sailor = sailor
        return true
    }
}
