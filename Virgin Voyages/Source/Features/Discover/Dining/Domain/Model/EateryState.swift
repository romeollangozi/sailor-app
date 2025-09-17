//
//  EateryState.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 26.11.24.
//

enum EateryState: String {
    case timeslotsAvailable = "TIMESLOTS_AVAILABLE"
    case timeslotsNotAvailable = "TIMESLOTS_NOT_AVAILABLE"
    case timeslotsBooked = "TIMESLOTS_BOOKED"
    case timeslotsBookedInPast = "TIMESLOTS_BOOKED_IN_PAST"
    case timeslotsSoldOut = "TIMESLOTS_SOLD_OUT"
    
    case soldOut = "SOLD_OUT"
    case soldOutPreCruise = "SOLD_OUT_PRE_CRUISE"
    case brunchClosed = "BRUNCH_CLOSED"
    case brunchOver = "BRUNCH_OVER"
    case dinnerClosed = "DINNER_CLOSED"
    case dinnerOver = "DINNER_OVER"
    case unknown // Default case for unrecognized values
    
    init(from string: String) {
        self = EateryState(rawValue: string) ?? .unknown
    }
}
