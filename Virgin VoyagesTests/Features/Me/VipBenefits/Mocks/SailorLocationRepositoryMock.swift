//
//  SailorLocationRepositoryMock.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/11/25.
//

import Foundation
@testable import Virgin_Voyages

final class SailorLocationRepositoryMock: LastKnownSailorConnectionLocationRepositoryProtocol {
    private var sailorLocation: SailorLocation
    
    init(sailorLocation: SailorLocation = .shore) {
        self.sailorLocation = sailorLocation
    }
    
	func fetchLastKnownSailorConnectionLocation() -> SailorLocation {
		return sailorLocation
	}

	func updateSailorConnectionLocation(_ sailorLocation: SailorLocation) throws {
		self.sailorLocation = sailorLocation
    }
}
