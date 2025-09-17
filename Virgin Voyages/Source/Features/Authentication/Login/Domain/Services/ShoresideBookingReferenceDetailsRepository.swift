//
//  ShoresideBookingReferenceDetailsRepository.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/29/24.
//

import Foundation

protocol ShoresideBookingReferenceDetailsRepositoryProtocol {
	func save(_ bookingDetails: ShoresideBookingReferenceDetails)
	func shoresideBookingReferenceDetails() -> ShoresideBookingReferenceDetails?
}

class ShoresideBookingReferenceDetailsRepository: ShoresideBookingReferenceDetailsRepositoryProtocol {

	private let shoresideBookingDetailsKey = "shoresideBookingDetails"

	func save(_ bookingDetails: ShoresideBookingReferenceDetails) {
		let encoder = JSONEncoder()
		if let encodedData = try? encoder.encode(bookingDetails.toDTO()) {
			UserDefaults.standard.set(encodedData, forKey: shoresideBookingDetailsKey)
		}
	}

	func shoresideBookingReferenceDetails() -> ShoresideBookingReferenceDetails? {
		if let savedData = UserDefaults.standard.data(forKey: shoresideBookingDetailsKey) {
			let decoder = JSONDecoder()
			return try? decoder.decode(ShoresideBookingReferenceDetailsDTO.self, from: savedData).toModel()
		}
		return nil
	}
}
