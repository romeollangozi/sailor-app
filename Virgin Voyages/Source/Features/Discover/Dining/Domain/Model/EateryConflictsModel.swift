//
//  EateriesConflictsModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 28.11.24.
//

struct EateryConflictsModel: Equatable {
    let conflict: ConflictDetails?
    
    struct PersonDetail: Equatable {
        let personId: String
        let count: Int
    }
    
    struct ConflictDetails: Equatable {
        let title: String
        let description: String
        let isSwap: Bool
        let isClash: Bool
		let isSoftClash: Bool
        let personDetails: [PersonDetail]
        var swapConflictDetails: SwapConflictDetails? = nil
    }
    
    struct SwapConflictDetails: Equatable {
        let cancellableRestaurantExternalId: String
        let cancellableRestaurantName: String
        let cancellableAppointmentDateTime: String
        let cancellableBookingLinkId: String
        
        let swappableRestaurantExternalId: String
        let swappableRestaurantName: String
        let swappableAppointmentDateTime: String
    }
}

extension EateryConflictsModel {
    static var none = EateryConflictsModel(conflict: nil)
}

extension EateryConflictsModel {
	static func softClash() -> EateryConflictsModel {
		return EateryConflictsModel(conflict: .init(title: "Confirm your booking",
													description: "You are double booked at this time—you can proceed, but you may not be able to be in two places at once.",
													isSwap: false,
													isClash: true,
													isSoftClash: true,
													personDetails: []))
	}
}

extension EateryConflictsModel {
	static func hardClash() -> EateryConflictsModel {
		return EateryConflictsModel(conflict: .init(title: "One or more of your party already has a dinner reservation on Monday",
													description: "You can only book one restaurant per night. We limit bookings so all our sailors have a chance to eat everywhere.",
													isSwap: false,
													isClash: true,
													isSoftClash: false,
													personDetails: []))
	}
}

extension EateryConflictsModel {
	static func repeatClash() -> EateryConflictsModel {
		return EateryConflictsModel(conflict: .init(title: "One or more of your party already has a dinner reservation at Wake",
													description: "We limit bookings so all our sailors have a chance to eat everywhere \n \nHowever it doesn’t mean you can’t eat at Wake again. We always reserve some walkins, so you can pop by and see if we have a table spare.",
													isSwap: false,
													isClash: true,
													isSoftClash: false,
													personDetails: []))
	}
}

extension EateryConflictsModel {
	static func swapClash() -> EateryConflictsModel {
		return EateryConflictsModel(conflict: .init(title: "Your party already has a dinner reservation for Wake",
													description: "You can only book dinner once per restaurant per voyage",
													isSwap: true,
													isClash: false,
													isSoftClash: false,
													personDetails: [],
													swapConflictDetails: .init(cancellableRestaurantExternalId: "12344", cancellableRestaurantName: "Wakt", cancellableAppointmentDateTime: "Wednesday 16th 8:00pm", cancellableBookingLinkId: "12345", swappableRestaurantExternalId: "1234", swappableRestaurantName: "Pink Agave", swappableAppointmentDateTime: "Thursday 17th 8:00pm")))
	}
}



