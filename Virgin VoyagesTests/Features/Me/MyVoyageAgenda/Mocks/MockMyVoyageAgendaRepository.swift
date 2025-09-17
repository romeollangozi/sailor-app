//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 9.3.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockMyVoyageAgendaRepository: MyVoyageAgendaRepositoryProtocol {
    var myVoyageAgenda: MyVoyageAgenda?
    var shouldThrowError = false
    
    func fetchMyVoyageAgenda(shipCode: String, reservationGuestId: String, useCache: Bool) async throws -> MyVoyageAgenda {
        if shouldThrowError {
			throw VVDomainError.genericError
        }
        return myVoyageAgenda ?? MyVoyageAgenda.empty()
    }
}
