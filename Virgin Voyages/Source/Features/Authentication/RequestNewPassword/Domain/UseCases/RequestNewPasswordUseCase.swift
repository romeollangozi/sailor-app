//
//  RequestNewPasswordUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 11.9.24.
//

import Foundation

// MARK: - Typealias
public typealias RequestNewPasswordResponse = (isEmailExist: Bool, isEmailSent: Bool)

class RequestNewPasswordUseCase {
    
    // MARK: - Properties
	private var service: NetworkServiceProtocol

    // MARK: - Init
	init(service: NetworkServiceProtocol = NetworkService.create()) {
        self.service = service

    }

    // MARK: - Execute
    func execute(email: String, clientToken: String, reCaptcha: String) async -> RequestNewPasswordResponse {
        do {
            let result = try await service.resetPassword(email: email, clientToken: clientToken, reCaptcha: reCaptcha)
            return (isEmailExist: result.isEmailExist, isEmailSent: result.isEmailSent)
        } catch {
            return (isEmailExist: false, isEmailSent: false)
        }
    }
}
