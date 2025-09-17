//
//  MockBookActivityUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.5.25.
//

import XCTest

@testable import Virgin_Voyages

final class MockBookActivityUseCase: BookActivityUseCaseProtocol {

	var input: Virgin_Voyages.BookActivityInputModel? = nil
   
    func execute(activity: any Virgin_Voyages.BookableActivity, slot: any Virgin_Voyages.BookableSlot, sailorDetails: [any Virgin_Voyages.BookableSailorDetails], operationType: Virgin_Voyages.BookingOperationType, bookableType: Virgin_Voyages.BookableType, payWithExistingCard: Bool, appointmentId: String?, appointmentLinkId: String?) async throws -> Virgin_Voyages.ActivityBookingServiceResult {
        return ActivityBookingServiceResult.success(.empty())

    }
	
	func execute(input: Virgin_Voyages.BookActivityInputModel) async throws -> Virgin_Voyages.ActivityBookingServiceResult {
		self.input = input
		
		return ActivityBookingServiceResult.success(.empty())
	}
}
