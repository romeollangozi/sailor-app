//
//  Appointments.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 16.1.25.
//

import Foundation

struct Appointments : Hashable {
    let id: String = UUID().uuidString
    let bannerText: String
    let items: [AppointmentItem]
}

struct AppointmentItem: Hashable {
    let id: String
	let linkId: String
    let slotId: String
    let startDateTime: Date
    let bannerText: String
	let sailors: [String]
	let isWithinCancellationWindow: Bool
}

extension Appointments {
	func copy(
		bannerText: String? = nil,
		items: [AppointmentItem]? = nil
	) -> Appointments {
		return Appointments(
			bannerText: bannerText ?? self.bannerText,
			items: items ?? self.items
		)
	}
}

extension Appointments {
	static func sample() -> Appointments {
		return .init(bannerText: "Booked, 11 Jan, 1:00pm", items: [.sample()])
	}
}

extension AppointmentItem {
	func copy(
		id: String? = nil,
		linkId: String? = nil,
		slotId: String? = nil,
        startDateTime: Date? = nil,
		bannerText: String? = nil,
		sailors: [String]? = nil,
		isWithinCancellationWindow: Bool? = nil
	) -> AppointmentItem {
		return AppointmentItem(
			id: id ?? self.id,
			linkId: linkId ?? self.linkId,
			slotId: slotId ?? self.slotId,
            startDateTime: startDateTime ?? self.startDateTime,
			bannerText: bannerText ?? self.bannerText,
			sailors: sailors ?? self.sailors,
			isWithinCancellationWindow: isWithinCancellationWindow ?? self.isWithinCancellationWindow
		)
	}
}

extension AppointmentItem {
	static func sample() -> AppointmentItem {
		return AppointmentItem(
			id: UUID().uuidString,
			linkId: "1",
			slotId: "1",
            startDateTime: Date(),
			bannerText: "1 ticket, Wed July 20, 9am",
			sailors: ["1"],
			isWithinCancellationWindow: true
		)
	}
}
