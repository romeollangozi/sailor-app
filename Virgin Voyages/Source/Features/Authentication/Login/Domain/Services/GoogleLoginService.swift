//
//  GoogleLoginService.swift
//  Virgin Voyages
//
//  Created by Pajtim on 17.9.24.
//

import Foundation
import GoogleSignIn

protocol GoogleLoginServiceProtocol {
    func signInWithGoogle(presentingViewController: UIViewController) async throws -> SocialUser
    var signInScopes: [String] { get }
}

class GoogleAuthService: GoogleLoginServiceProtocol {
    
    internal let signInScopes = [
        "profile",
        "email",
        "https://www.googleapis.com/auth/user.birthday.read"
    ]

    func signInWithGoogle(presentingViewController: UIViewController) async throws -> SocialUser {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController, hint: nil, additionalScopes: self.signInScopes) { signInResult, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let user = signInResult?.user {
                        let userInfo = SocialUser(
                            id: user.userID ?? "",
                            firstName: user.profile?.givenName ?? "",
                            lastName: user.profile?.familyName ?? "",
                            email: user.profile?.email ?? "",
                            profileImageUrl: user.profile?.imageURL(withDimension: 100)?.absoluteString,
                            socialNetworkAPIAccessToken: user.accessToken.tokenString
                        )
                        continuation.resume(returning: userInfo)
                    } else {
                        continuation.resume(throwing: "" as! Error)
                    }
                }
            }
        }
    }
}
