//
//  MyVoyageRepositoryMock.swift
//  Virgin VoyagesTests
//
//  Created by TX on 13.3.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockMyVoyageRepository: MyVoyageRepositoryProtocol {
    var mockSailingMode: SailingMode?
    var shouldThrowError: Bool = false
    var errorToThrow: Error = VVDomainError.genericError

    func fetchMyVoyageStatus(reservationNumber: String, reservationGuestId: String) async throws -> SailingMode? {
        if shouldThrowError {
            throw errorToThrow
        }
        return mockSailingMode
    }
}
