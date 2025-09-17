//
//  AddOnRepositoryProtocol.swift
//  Virgin Voyages
//
//  Moved to Domain/Repositories to follow Clean Architecture.
//

import Foundation

protocol AddOnRepositoryProtocol {
    func getAddOns(code: String?) async throws -> Result<AddOnDetails, Error>
    func getAddOnDetails(code: String) async throws -> GetAddonsDetailsResponse?
}

