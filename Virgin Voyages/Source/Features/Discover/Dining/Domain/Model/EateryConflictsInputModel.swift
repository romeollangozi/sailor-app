//
//  EateriesConflictsInputModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 28.11.24.
//

import Foundation

struct EateryConflictsInputModel  {
	struct PersonDetail {
		let personId: String
	}
	
	let personDetails: [PersonDetail]
	let activityCode: String
	let activitySlotCode: String
	let startDateTime: Date
	let mealPeriod: MealPeriod
}

extension EateryConflictsInputModel {
	static func empty() -> EateryConflictsInputModel {
		return EateryConflictsInputModel(
			personDetails: [],
			activityCode: "",
			activitySlotCode: "",
			startDateTime: Date(),
			mealPeriod: .dinner
		)
	}
	
	static func sampleWithDinner() -> EateryConflictsInputModel {
		return EateryConflictsInputModel(
			personDetails: [],
			activityCode: "",
			activitySlotCode: "",
			startDateTime: Date(),
			mealPeriod: .dinner
		)
	}
	
	func copy(
		personDetails: [PersonDetail]? = nil,
		activityCode: String? = nil,
		activitySlotCode: String? = nil,
		startDateTime: Date? = nil,
		mealPeriod: MealPeriod? = nil
	) -> EateryConflictsInputModel {
		return EateryConflictsInputModel(
			personDetails: personDetails ?? self.personDetails,
			activityCode: activityCode ?? self.activityCode,
			activitySlotCode: activitySlotCode ?? self.activitySlotCode,
			startDateTime: startDateTime ?? self.startDateTime,
			mealPeriod: mealPeriod ?? self.mealPeriod
		)
	}
}
