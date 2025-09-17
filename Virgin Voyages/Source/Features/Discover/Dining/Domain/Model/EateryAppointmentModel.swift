//
//  EateryAppointmentModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 5.12.24.
//

import Foundation

struct EateryAppointmentModel : Equatable {
    let appointmentId: String
    let appointmentLinkId: String
    let eateryName: String
    let eateryExternalId: String
    let eateryVenueId: String
    let guests: [String]
    let slotCode: String
	let startDateTime: Date
    let mealPeriod: MealPeriod
    let groupType: BookingGroupTypeV2
    let isWithinCancellationWindow: Bool
    let id: String = UUID().uuidString
}

extension EateryAppointmentModel {
    static var sample =  EateryAppointmentModel(appointmentId: "5b52cf59-9928-4854-aa79-71bb0f9dc031",
                                                appointmentLinkId: "a59c3c43-51d1-4426-989e-bfecede744cb",
                                                eateryName: "The Test Kitchen",
                                                eateryExternalId: "5a4bf485da0c112a66ed6263",
                                                eateryVenueId: "1dbce3e9-914a-4a05-bcf6-31f75434c362",
                                                guests: [],
                                                slotCode: "1732644900000-1732652100000",
                                                startDateTime: Date(),
                                                mealPeriod: MealPeriod.dinner,
                                                groupType: BookingGroupTypeV2.Individual,
                                                isWithinCancellationWindow: true)
}

