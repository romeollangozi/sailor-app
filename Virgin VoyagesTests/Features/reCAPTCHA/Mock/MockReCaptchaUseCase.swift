//
//  MockReCaptchaUseCase.swift
//  Virgin VoyagesTests
//
//  Created by TX on 8.7.25.
//

import Foundation
import XCTest
@testable import Virgin_Voyages

class MockReCaptchaUseCaseSuccess: ReCaptchaUseCaseProtocol {
    func execute(action: String) async -> ReCaptchaResponse {
        return ReCaptchaResponse(status: true, token: "valid_token", error: nil)
    }
}

class MockReCaptchaUseCaseFailure: ReCaptchaUseCaseProtocol {
    func execute(action: String) async -> ReCaptchaResponse {
        return ReCaptchaResponse(status: false, token: nil, error: "Recaptcha failed")
    }
}

class MockReCaptchaUseCaseNilToken: ReCaptchaUseCaseProtocol {
    func execute(action: String) async -> ReCaptchaResponse {
        return ReCaptchaResponse(status: false, token: nil, error: nil)
    }
}
