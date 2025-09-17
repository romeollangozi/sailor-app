//
//  RequestNewPasswordUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 14.9.24.
//
//import XCTest
//import Foundation
//@testable import Virgin_Voyages
//
//class RequestNewPasswordUseCaseTests: XCTestCase {
//
//    func testRequestNewPasswordUseCaseSuccess() async {
//        let mockService = MockRequestPasswordService()
//        let useCase = RequestNewPasswordUseCase(service: mockService)
//
//        let result = await useCase.execute(email: "test@example.com", clientToken: "mock-token", reCaptcha: "mock-captcha")
//        
//        XCTAssertTrue(result.isEmailExist)
//        XCTAssertTrue(result.isEmailSent)
//        XCTAssertNil(result.error)
//    }
//    
//    func testRequestNewPasswordUseCaseFailure() async {
//        let mockService = MockRequestPasswordService()
//        mockService.shouldSucceed = false
//        let useCase = RequestNewPasswordUseCase(service: mockService)
//
//        let result = await useCase.execute(email: "test@example.com", clientToken: "mock-token", reCaptcha: "mock-captcha")
//        
//        XCTAssertFalse(result.isEmailExist)
//        XCTAssertFalse(result.isEmailSent)
//        XCTAssertNotNil(result.error)
//    }
//}
