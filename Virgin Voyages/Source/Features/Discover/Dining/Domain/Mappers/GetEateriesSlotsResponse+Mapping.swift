//
//  GetEateriesSlotsResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 12.5.25.
//

import Foundation

extension GetEateriesSlotsResponse {
	func toDomain() -> EateriesSlots {
		return EateriesSlots(restaurants: self.restaurants?.map {$0.toDomain()} ?? [])
	}
}

extension GetEateriesSlotsResponse.Restaurant {
	func toDomain() -> EateriesSlots.Restaurant {
		.init(name: self.name.value,
					 externalId: self.externalId.value,
					 venueId: self.venueId.value,
					 state: EateryState(rawValue: self.state.value) ?? .unknown,
					 stateText: self.stateText.value,
					 disclaimer: self.disclaimer,
					 slots: self.slots?.map({slot in slot.toDomain()}) ?? [],
					 appointment: self.appointment?.toDomain(),
					 appointments:  self.appointments?.toDomain()
	)}
}
