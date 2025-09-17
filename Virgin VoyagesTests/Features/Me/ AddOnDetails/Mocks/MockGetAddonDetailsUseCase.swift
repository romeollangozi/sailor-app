//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 9.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class MockGetAddonDetailsUseCase: GetAddonDetailsUseCaseProtocol {
    var expectedExecuteResult: AddonDetailsModel?
    var shouldThrowErrorInExecute = false
    
    func execute(addonCode: String) async throws -> AddonDetailsModel {
        if shouldThrowErrorInExecute {
			throw VVDomainError.genericError
        }
        return expectedExecuteResult ?? AddonDetailsModel()
    }
}
