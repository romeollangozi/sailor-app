//
//  AddContactData+Mapping.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 10.9.25.
//

import Foundation

extension AddContactData {
	static func from(sailorLink: String) -> AddContactData {
		let urlComponents = URLComponents(string: sailorLink)
		let queryItems = urlComponents?.queryItems ?? []

		func value(for key: String) -> String {
			queryItems.first(where: { $0.name == key })?.value ?? ""
		}

		return AddContactData(
			reservationGuestId: value(for: "reservationGuestId"),
			reservationId: value(for: "reservationId"),
			voyageNumber: value(for: "voyageNumber"),
			name: value(for: "name")
		)
	}
}
