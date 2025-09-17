//
//  SailorProfileV2RepositoryMock.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 27.3.25.
//

import Foundation
@testable import Virgin_Voyages

class SailorProfileV2RepositoryMock: SailorProfileV2RepositoryProtocol {
    var mockSailorProfile: SailorProfileV2?
    var shouldThrowError: Bool = false
    
    func getSailorProfile(reservationNumber: String? = nil) async throws -> SailorProfileV2? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return mockSailorProfile
    }
}
