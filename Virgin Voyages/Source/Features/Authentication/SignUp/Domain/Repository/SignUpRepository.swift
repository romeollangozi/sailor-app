//
//  SignUpRepository.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/5/25.
//

import Foundation

protocol SignUpRepositoryProtocol {
    func getValidateEmail(email: String, clientToken: String) async throws -> ValidateEmail?
}

final class SignUpRepository: SignUpRepositoryProtocol {
    
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func getValidateEmail(email: String, clientToken: String) async throws -> ValidateEmail? {
        
        let validateEmail = try await networkService.signUpEmailValidation(email: email, clientToken: clientToken)
        
        return validateEmail?.toDomain()
    }
    
}
