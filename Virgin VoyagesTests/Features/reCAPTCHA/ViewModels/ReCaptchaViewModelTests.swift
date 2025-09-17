//
//  ReCaptchaViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 8.7.25.
//

import Foundation
import XCTest
@testable import Virgin_Voyages

final class ReCaptchaViewModelTests: XCTestCase {

    func testVerifyToken_SuccessfulResponse() async {
        let mockUseCase = MockReCaptchaUseCaseSuccess()
        let viewModel = ReCaptchaViewModel(action: "test-action", recaptchaUseCase: mockUseCase)

        executeAndWaitForAsyncOperation {
            viewModel.verifyToken()
        }

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.reCaptchaStatus.status)
        XCTAssertEqual(viewModel.reCaptchaStatus.token, "valid_token")
        XCTAssertNil(viewModel.error)
    }

    func testVerifyToken_FailureWithError() async {
        let mockUseCase = MockReCaptchaUseCaseFailure()
        let viewModel = ReCaptchaViewModel(action: "test-action", recaptchaUseCase: mockUseCase)

        executeAndWaitForAsyncOperation {
            viewModel.verifyToken()
        }

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.reCaptchaStatus.status)
        XCTAssertNil(viewModel.reCaptchaStatus.token)
        XCTAssertEqual(viewModel.error, "Recaptcha failed")
    }

    func testVerifyToken_FailureWithoutError() async {
        let mockUseCase = MockReCaptchaUseCaseNilToken()
        let viewModel = ReCaptchaViewModel(action: "test-action", recaptchaUseCase: mockUseCase)

        executeAndWaitForAsyncOperation {
            viewModel.verifyToken()
        }

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.reCaptchaStatus.status)
        XCTAssertNil(viewModel.reCaptchaStatus.token)
        XCTAssertNil(viewModel.error)
    }

    func testViewModel_InitialState() {
        let viewModel = ReCaptchaViewModel(action: "initial", recaptchaUseCase: MockReCaptchaUseCaseSuccess())
        XCTAssertEqual(viewModel.action, "initial")
        XCTAssertFalse(viewModel.reCaptchaStatus.status)
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.isLoading)
    }
}
