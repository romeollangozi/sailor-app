//
//  ApplicationFlow.swift
//  Virgin Voyages
//
//  Created by TX on 21.7.25.
//

enum ApplicationFlow {
    case initialLoading
    case loggedOut
    case loggedIn
    case loadingReservation
    case voyageUpdate
    case reservationNotFound
	case voyageCancelled
	case voyageNotFound
	case guestNotFound
    case authenticationServiceError
}
