//
//  ShipsideBookingReferenceDetailsRepository.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/30/24.
//

import Foundation

protocol ShipsideBookingReferenceDetailsRepositoryProtocol {
	func save(_ bookingDetails: ShipsideBookingReferenceDetails)
	func shipsideBookingReferenceDetails() -> ShipsideBookingReferenceDetails?
}

class ShipsideBookingReferenceDetailsRepository: ShipsideBookingReferenceDetailsRepositoryProtocol {

	private let shipsideBookingDetailsKey = "shipsideBookingDetails"

	func save(_ bookingDetails: ShipsideBookingReferenceDetails) {
		let encoder = JSONEncoder()
		if let encodedData = try? encoder.encode(bookingDetails.toDTO()) {
			UserDefaults.standard.set(encodedData, forKey: shipsideBookingDetailsKey)
		}
	}

	func shipsideBookingReferenceDetails() -> ShipsideBookingReferenceDetails? {
		if let savedData = UserDefaults.standard.data(forKey: shipsideBookingDetailsKey) {
			let decoder = JSONDecoder()
			return try? decoder.decode(ShipsideBookingReferenceDetailsDTO.self, from: savedData).toModel()
		}
		return nil
	}
}
