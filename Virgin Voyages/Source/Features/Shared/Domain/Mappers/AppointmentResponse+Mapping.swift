//
//  AppointmentResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 8.5.25.
//

import Foundation

extension AppointmentsResponse {
	func toDomain() -> Appointments {
		return Appointments(
			bannerText: self.bannerText.value,
			items: self.items?.map { $0.toDomain() } ?? []
		)
	}
}

extension AppointmentsResponse.AppointmentItemResponse {
	func toDomain() -> AppointmentItem {
		AppointmentItem(id: self.id.value,
						linkId: self.linkId.value,
						slotId: self.slotId.value,
                        startDateTime: Date.fromISOString(string: self.startDateTime),
						bannerText: self.bannerText.value,
						sailors: self.sailors?.map({sailorId in sailorId}) ?? [],
						isWithinCancellationWindow: self.isWithinCancellationWindow.value)
	}
}
