//
//  MockMessengerLandingScreenUseCase.swift
//  Virgin VoyagesTests
//
//  Created by Timur Xhabiri on 28.10.24.
//

@testable import Virgin_Voyages
import XCTest

// MARK: - Mock Use Case
class MockMessengerLandingScreensUseCase: MessengerLandingScreensUseCaseProtocol {
    
    var result: Result<MessengerLandingScreenModel, VVDomainError>?
    var error: Result<MessengerLandingScreenModel, VVDomainError>?

    func execute() async -> Result<MessengerLandingScreenModel, VVDomainError> {
        return result ?? error ?? .success(.init())
    }
}

