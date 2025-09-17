//
//  MockCancelAddonUseCase.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 11.7.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockCancelAddonUseCase: CancelAddonUseCaseProtocol {
    var cancelledGuests: [String] = []
    var cancelledCode: String = ""

    func cancelAddon(guests: [String], code: String, quantity: Int) async -> Result<Bool, VVDomainError> {
        cancelledGuests = guests
        cancelledCode = code
        return .success(true)
    }
}
