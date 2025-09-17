//
//  LoginWithAppleService.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 16.9.24.
//

import AuthenticationServices

protocol AppleLoginServiceProtocol: AnyObject {
    func requestToken() async -> SocialUser?
}

class AppleLoginService: NSObject, ObservableObject, AppleLoginServiceProtocol {
    private var continuation: CheckedContinuation<ASAuthorizationAppleIDCredential, Error>?
        
    // MARK: - Sign in with Apple
    func requestToken() async -> SocialUser? {
        do {
            let credential = try await performSignInWithApple()
            let firstName = credential.fullName?.givenName
            let lastName = credential.fullName?.familyName
            return SocialUser(id: credential.user, firstName: firstName, lastName: lastName, email: credential.email, profileImageUrl: nil)
        } catch {
            return nil
        }
    }

    // MARK: - Perform sign in with Apple
    private func performSignInWithApple() async throws -> ASAuthorizationAppleIDCredential {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else { return }
            
            self.continuation = continuation
           
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.performRequests()
        }
    }
}

extension AppleLoginService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: CancellationError())
            continuation = nil
            return
        }

        continuation?.resume(returning: credential)
        continuation = nil
    }
                                                      
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}
