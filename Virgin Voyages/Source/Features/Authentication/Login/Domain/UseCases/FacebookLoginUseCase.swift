//
//  FacebookLoginUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 19.9.24.
//

import Foundation
import SwiftUI

protocol FacebookLoginUseCaseProtocol {
    func execute() async throws -> SocialUser?
}

class FacebookLoginUseCase: FacebookLoginUseCaseProtocol {
    
    // MARK: - Properties
    private let authService: FacebookLoginServiceProtocol

    // MARK: - Init
    init(authService: FacebookLoginServiceProtocol = FacebookLoginService()) {
        self.authService = authService
    }

    // MARK: - Execute
    func execute() async throws -> SocialUser? {
        return try await authService.loginWithFacebookAsync()
    }
}
