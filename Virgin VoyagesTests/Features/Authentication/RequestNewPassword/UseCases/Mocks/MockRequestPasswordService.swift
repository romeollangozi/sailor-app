//
//  MockRequestPasswordService.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 14.9.24.
//

import XCTest
import Foundation
@testable import Virgin_Voyages

//class MockRequestPasswordService: RequestPasswordServiceProtocol {
//    
//    var shouldSucceed = true
//    
//    func clientToken() async -> Result<String, APIError> {
//        if shouldSucceed {
//            return .success("mock-token")
//        } else {
//            return .failure(.customError("error"))
//        }
//    }
//    
//    func resetPassword(email: String, clientToken: String, reCaptcha: String) async -> Result<ResetPasswordDTO, APIError> {
//        if shouldSucceed {
//            return .success(ResetPasswordDTO(isEmailExist: true, isEmailSent: true))
//        }else {
//            return .failure(.customError("could not reset password"))
//        }
//    }
//}
