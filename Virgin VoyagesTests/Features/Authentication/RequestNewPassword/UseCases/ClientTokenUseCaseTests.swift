//
//  ClientTokenUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 14.9.24.
//

import XCTest
import Foundation
@testable import Virgin_Voyages

//class ClientTokenUseCaseTests: XCTestCase {
//
//    func testClientTokenUseCaseSuccess() async {
//        let mockService = MockRequestPasswordService()
//        let useCase = ClientTokenUseCase(service: mockService)
//
//        let result = await useCase.execute()
//        
//        XCTAssertEqual(result.token, "mock-token")
//        XCTAssertNil(result.error)
//    }
//    
//    func testClientTokenUseCaseFailure() async {
//        let mockService = MockRequestPasswordService()
//        mockService.shouldSucceed = false
//        let useCase = ClientTokenUseCase(service: mockService)
//
//        let result = await useCase.execute()
//        XCTAssertEqual(result.token, "")
//        XCTAssertEqual(result.error, "error")
//    }
//}
