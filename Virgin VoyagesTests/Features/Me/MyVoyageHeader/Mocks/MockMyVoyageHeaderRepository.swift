//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 9.3.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockMyVoyageHeaderRepository: MyVoyageHeaderRepositoryProtocol {
    var myVoyageHeader: MyVoyageHeader?
    var shouldThrowError = false
    
	func fetchMyVoyageHeader(reservationGuestId: String, reservationNumber: String, useCache: Bool) async throws -> MyVoyageHeader {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return myVoyageHeader ?? MyVoyageHeader.empty()
    }
}
