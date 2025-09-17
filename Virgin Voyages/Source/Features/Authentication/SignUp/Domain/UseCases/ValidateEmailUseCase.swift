//
//  ValidateEmailUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/5/25.
//

import Foundation

protocol ValidateEmailUseCaseProtocol {
    func execute(email: String, clientToken: String) async throws -> ValidateEmail
}

class ValidateEmailUseCase: ValidateEmailUseCaseProtocol {
    
    // MARK: - Properties
    private var signUpRepository: SignUpRepositoryProtocol

    // MARK: - Init
    init(signUpRepository: SignUpRepositoryProtocol = SignUpRepository()) {
        self.signUpRepository = signUpRepository
    }
    
    // MARK: - Execute
    func execute(email: String, clientToken: String) async throws -> ValidateEmail {
        
        guard let validateEmail = try await signUpRepository.getValidateEmail(email: email, clientToken: clientToken) else {
            
            throw VVDomainError.genericError
        }
        
        return validateEmail
    }

}
