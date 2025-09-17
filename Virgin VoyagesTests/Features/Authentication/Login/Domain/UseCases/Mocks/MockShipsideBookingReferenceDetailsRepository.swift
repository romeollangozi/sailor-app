//
//  MockShipsideBookingReferenceDetailsRepository.swift
//  Virgin VoyagesTests
//
//  Created by Abel Duarte on 8/30/24.
//

import Foundation
@testable import Virgin_Voyages

class MockShipsideBookingReferenceDetailsRepository: ShipsideBookingReferenceDetailsRepositoryProtocol {
	var savedDetails: ShipsideBookingReferenceDetails?

	func save(_ bookingDetails: ShipsideBookingReferenceDetails) {
		savedDetails = bookingDetails
	}

	func shipsideBookingReferenceDetails() -> ShipsideBookingReferenceDetails? {
		return savedDetails
	}
}
