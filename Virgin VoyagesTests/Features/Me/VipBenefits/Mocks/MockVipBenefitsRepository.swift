//
//  MockVipBenefitsRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 6.3.25.
//

import Foundation
@testable import Virgin_Voyages

class MockVipBenefitsRepository: VipBenefitsRepositoryProtocol {
	var mockResponse: VipBenefits?

	func fetchVipBenefits(guestTypeCode: String, shipCode: String) async throws -> VipBenefits? {
		return mockResponse
	}
}
