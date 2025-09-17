//
//  ClaimABookingCoordinator.swift
//  Virgin Voyages
//
//  Created by TX on 21.1.25.
//

import Foundation

enum ClaimABookingNavigationRoute: BaseNavigationRoute {
	case landing
    case bookingDetails
    case bookingNotFound
    case manualEntry
    case emailConflict(email: String, reservationNumber: String, reservationGuestID: String)
    case guestConflict(currentGuest: ClaimBookingGuestDetails?, bookingReferenceNumber: String, guestDetails: [ClaimBookingGuestDetails])
    case successRequiresAuthentication
    case checkBookingDetails(bookingReferenceNumber: String, selectedGuest: ClaimBookingGuestDetails)
    case missingBookingDetails(bookingReferenceNumber: String, selectedGuest: ClaimBookingGuestDetails)
}

@Observable class ClaimABookingCoordinator {
    
    var navigationRouter: NavigationRouter<ClaimABookingNavigationRoute>

    init(navigationRouter: NavigationRouter<ClaimABookingNavigationRoute> = .init()) {
        self.navigationRouter = navigationRouter
    }
}
