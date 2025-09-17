//
//  DeepLinkGenerator.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 13.11.24.
//

import Foundation

class DeepLinkGenerator {
	public static func generate(
		reservationGuestId: String,
		reservationId: String,
		voyageNumber: String,
		name: String) -> String {
		let url = "https://www.virginvoyages.com/addContact"

		var components = URLComponents(string: url)
		components?.queryItems = [
			URLQueryItem(name: "type", value: "add.contact"),
			URLQueryItem(name: "reservationGuestId", value: reservationGuestId),
			URLQueryItem(name: "reservationId", value: reservationId),
			URLQueryItem(name: "voyageNumber", value: voyageNumber),
			URLQueryItem(name: "name", value: name)
		]
			return components?.url?.absoluteString ?? ""
	}
}
