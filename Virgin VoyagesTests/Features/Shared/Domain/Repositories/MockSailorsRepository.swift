//
//  MockSailorsRepository.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.3.25.
//

import Foundation
@testable import Virgin_Voyages

class MockSailorsRepository: SailorsRepositoryProtocol {
	func fetchMySailors(reservationGuestId: String, reservationNumber: String, useCache: Bool, appointmentLinkId: String?) async throws -> [Virgin_Voyages.SailorModel] {
		return sailors
	}
	
	var sailors: [SailorModel] = []
}
