//
//  AppleLoginUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 16.9.24.
//

import Foundation

protocol AppleLoginUseCaseProtocol {
    func execute() async -> SocialUser?
}

class AppleLoginUseCase: AppleLoginUseCaseProtocol {
    
    // MARK: - Properties
    let service: AppleLoginServiceProtocol
    
    // MARK: - Init
    init(service: AppleLoginServiceProtocol = AppleLoginService()) {
        self.service = service
    }
    
    // MARK: - Execute
    func execute() async -> SocialUser? {
        let result = await service.requestToken()
        return result
    }
}
