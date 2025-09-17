//
//  MockLastKnownSailorConnectionLocationRepository.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.5.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockLastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol {
	var lastSailorLocation: Virgin_Voyages.SailorLocation = .shore
	var shouldThrowError: Bool = false
	
	func fetchLastKnownSailorConnectionLocation() -> Virgin_Voyages.SailorLocation {
		return lastSailorLocation
	}
	
	func updateSailorConnectionLocation(_ sailorLocation: Virgin_Voyages.SailorLocation) throws {
		if shouldThrowError {
			throw VVDomainError.genericError
		}
		
		lastSailorLocation = sailorLocation
	}
}

