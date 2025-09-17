//
//  EateriesSlotsInputModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 25.11.24.
//

import Foundation

struct EateriesSlotsInputModel : Equatable, Hashable {
	var searchSlotDate: Date = Date()
	var mealPeriod: MealPeriod = MealPeriod.dinner
	var venues: [Venue] = []
	var guests: [SailorModel] = []
	
	static func == (lhs: EateriesSlotsInputModel, rhs: EateriesSlotsInputModel) -> Bool {
		return lhs.searchSlotDate == rhs.searchSlotDate &&
		lhs.mealPeriod == rhs.mealPeriod &&
		lhs.venues == rhs.venues &&
		lhs.guests == rhs.guests
	}
	
	struct Venue: Equatable, Hashable {
		let externalId: String
		let venueId: String
	}
}

extension EateriesSlotsInputModel {
	static let sample = EateriesSlotsInputModel(searchSlotDate: Date(),
												mealPeriod: MealPeriod.dinner,
												venues: [],
												guests: [
													SailorModel(id: "659e9fb8-e897-4f59-aa08-99d8913a3b75",
																guestId: "659e9fb8-e897-4f59-aa08-99d8913a3b75",
																reservationGuestId: "659e9fb8-e897-4f59-aa08-99d8913a3b75",
																reservationNumber: "11111",
																name: "John",
																profileImageUrl: nil,
																isCabinMate: true,
																isLoggedInSailor: false),
													SailorModel(id: "179d3cd1-4fd6-4fe8-9946-caf9de5bb698",
																guestId: "179d3cd1-4fd6-4fe8-9946-caf9de5bb698",
																reservationGuestId: "179d3cd1-4fd6-4fe8-9946-caf9de5bb698",
																reservationNumber: "11111",
																name: "Anna",
																profileImageUrl: nil,
																isCabinMate: false,
																isLoggedInSailor: false)
												])
}
