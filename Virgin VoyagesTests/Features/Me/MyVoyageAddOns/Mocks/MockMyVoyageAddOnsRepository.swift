//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 9.3.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockMyVoyageAddOnsRepository: MyVoyageAddOnsRepositoryProtocol {
    var myVoyageAddOns: MyVoyageAddOns?
    var shouldThrowError = false
    
    func fetchMyVoyageAddOns(reservationNumber: String, shipCode: String, guestId: String, useCache: Bool) async throws -> MyVoyageAddOns? {
        if shouldThrowError {
			throw VVDomainError.genericError
        }
        return myVoyageAddOns ?? MyVoyageAddOns.empty()
    }
}
