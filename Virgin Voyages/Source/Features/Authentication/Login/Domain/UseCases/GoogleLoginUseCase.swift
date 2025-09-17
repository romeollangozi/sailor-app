//
//  GoogleLoginUseCase.swift
//  Virgin Voyages
//
//  Created by Pajtim on 17.9.24.
//

import Foundation
import SwiftUI

protocol GoogleLoginUseCaseProtocol {
    func execute(presentingViewController: UIViewController) async throws -> SocialUser
}

class GoogleLoginUseCase: GoogleLoginUseCaseProtocol {
    
    // MARK: - Properties
    private let authService: GoogleLoginServiceProtocol
    private let googleAPIService: GoogleAPIServiceProtocol

    // MARK: - Init
    init(authService: GoogleLoginServiceProtocol = GoogleAuthService(),
         googleAPIService: GoogleAPIServiceProtocol = GoogleAPIService()) {
        self.authService = authService
        self.googleAPIService = googleAPIService
    }

    // MARK: - Execute
    func execute(presentingViewController: UIViewController) async throws -> SocialUser {
        var user = try await authService.signInWithGoogle(presentingViewController: presentingViewController)
        // Atempt to set the date of birth 
        if let dateOfBirth = await fetchBirthdate(for: user) {
            user.dateOfBirth = dateOfBirth
        }
        return user
    }
    
    private func fetchBirthdate(for user: SocialUser) async -> Date? {
        // fetch birthdate
        if let accessToken = user.socialNetworkAPIAccessToken {
            googleAPIService.configure(with: accessToken)
            return await googleAPIService.runAPIRequest(request: .fetchBirthdate)
        } else {
            print("GoogleLoginUseCase Warning - Couldn't fetch birthdate. No access token.")
            return nil
        }
    }
}
