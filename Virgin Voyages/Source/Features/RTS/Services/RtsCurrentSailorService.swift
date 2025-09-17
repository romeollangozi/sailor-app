//
//  TravelDocsSailorManager.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 28.4.25.
//

struct RtsCurrentSailor {
    let reservationGuestId: String
}

protocol RtsCurrentSailorProtocol {
    func getCurrentSailor() -> RtsCurrentSailor
    func setSailor(sailor: RtsCurrentSailor) -> Bool
}

class RtsCurrentSailorService: RtsCurrentSailorProtocol {
    static let shared = RtsCurrentSailorService()
    
    private var travelDocsSailor: RtsCurrentSailor = RtsCurrentSailor(reservationGuestId: "")
    
    init() {}
    
    func getCurrentSailor() -> RtsCurrentSailor {
        return travelDocsSailor
    }
    
    @discardableResult
    func setSailor(sailor: RtsCurrentSailor) -> Bool {
        self.travelDocsSailor = sailor
        return true
    }
}
