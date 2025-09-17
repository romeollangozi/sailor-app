//
//  EateriesSlots.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 25.11.24.
//

import Foundation

struct EateriesSlots: Equatable {
	let restaurants: [Restaurant]
	
    struct Restaurant: Equatable {
		let name: String
		let externalId: String
		let venueId: String
		let state: EateryState
		let stateText: String
		let disclaimer: String?
		let slots: [Slot]
		//This the appointment for the meal type in for a specific date
		let appointment: AppointmentItem?
		//This appointments in case of the details it returns all the appointments while on the list it returns only for that date
		let appointments: Appointments?
	}
}

extension EateriesSlots {
	static func sample() -> EateriesSlots {
		return EateriesSlots(
			restaurants: [.sample()]
		)
	}
}

extension EateriesSlots.Restaurant {
	static func sample() -> EateriesSlots.Restaurant {
		.init(
			name: "Gunbae",
			externalId: "5a4bf486da0c112a66ed630b",
			venueId: "90f2d279-c716-4f5d-a1cd-7bc49df8dc8d",
			state: .timeslotsAvailable,
			stateText: "Available",
			disclaimer: nil,
			slots: [Slot.sample()],
			appointment: nil,
			appointments: nil
		)
	}
}


extension EateriesSlots.Restaurant {
	func copy(
		name: String? = nil,
		externalId: String? = nil,
		venueId: String? = nil,
		state: EateryState? = nil,
		stateText: String? = nil,
		disclaimer: String?? = nil,
		slots: [Slot]? = nil,
		appointment: AppointmentItem? = nil,
		appointments: Appointments?? = nil
	) -> EateriesSlots.Restaurant {
		return EateriesSlots.Restaurant(
			name: name ?? self.name,
			externalId: externalId ?? self.externalId,
			venueId: venueId ?? self.venueId,
			state: state ?? self.state,
			stateText: stateText ?? self.stateText,
			disclaimer: disclaimer ?? self.disclaimer,
			slots: slots ?? self.slots,
			appointment: appointment ?? self.appointment,
			appointments: appointments ?? self.appointments
		)
	}
}

extension EateriesSlots.Restaurant {
	static func empty() -> EateriesSlots.Restaurant {
		.init(
			name: "",
			externalId: "",
			venueId: "",
			state: .timeslotsAvailable,
			stateText: "",
			disclaimer: nil,
			slots: [],
			appointment: nil,
			appointments: nil
		)
	}
}

extension EateriesSlots {
	static func empty() -> EateriesSlots {
		return EateriesSlots(
			restaurants: []
		)
	}
}

extension EateriesSlots {
	func onlyThoseWithTimeslotsAvailable() -> EateriesSlots {
		return EateriesSlots(restaurants: restaurants.filter { $0.slots.count > 0 })
	}
}


extension EateriesSlots {
	func find(byExternalId externalId: String, byVenueId venueId: String) -> EateriesSlots.Restaurant? {
		restaurants.first(where: { $0.externalId == externalId && $0.venueId == venueId })
	}
}
