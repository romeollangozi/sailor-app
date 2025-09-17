//
//  AppointmentsResponse.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 8.5.25.
//

struct AppointmentsResponse: Decodable {
	let bannerText: String?
	let items: [AppointmentItemResponse]?
	
	struct AppointmentItemResponse: Decodable {
		let id: String?
		let linkId: String?
		let slotId: String?
        let startDateTime: String?
		let bannerText: String?
		let sailors: [String]?
		let isWithinCancellationWindow: Bool?
	}
}
