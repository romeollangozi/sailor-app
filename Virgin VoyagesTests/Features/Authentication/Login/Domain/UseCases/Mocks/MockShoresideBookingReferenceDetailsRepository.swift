//
//  MockShoresideBookingReferenceDetailsRepository.swift
//  Virgin VoyagesTests
//
//  Created by Abel Duarte on 8/30/24.
//

import Foundation
@testable import Virgin_Voyages

class MockShoresideBookingReferenceDetailsRepository: ShoresideBookingReferenceDetailsRepositoryProtocol {
	var savedDetails: ShoresideBookingReferenceDetails?

	func save(_ bookingDetails: ShoresideBookingReferenceDetails) {
		savedDetails = bookingDetails
	}

	func shoresideBookingReferenceDetails() -> ShoresideBookingReferenceDetails? {
		return savedDetails
	}
}
