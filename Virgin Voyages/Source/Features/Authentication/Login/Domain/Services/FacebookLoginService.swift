//
//  FacebookLoginService.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 19.9.24.
//

import Foundation
import FacebookLogin

protocol FacebookLoginServiceProtocol {
    func loginWithFacebookAsync() async throws -> SocialUser?
}

class FacebookLoginService: FacebookLoginServiceProtocol {

    // MARK: - LoginWithFacebookAsync
    func loginWithFacebookAsync() async throws -> SocialUser? {
        return try await withCheckedThrowingContinuation { continuation in
            loginWithFacebook { user, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let user = user {
                    continuation.resume(returning: user)
                } else {
                    continuation.resume(throwing: NSError(domain: "Login failed", code: -1, userInfo: nil))
                }
            }
        }
    }
    
    // MARK: - LoginWithFacebook
    private func loginWithFacebook(completion: @escaping ((SocialUser?, Error?) -> Void)) {
        let loginManager = LoginManager()
        DispatchQueue.main.async {
            loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
                if let error = error {
                    completion(nil, error)
                }
                
                guard let result = result, !result.isCancelled else {
                    return completion(nil, NSError(domain: "Canceled", code: -1, userInfo: nil))
                }
                
                if let tokenString = result.token?.tokenString {
                    self.fetchFacebookProfile(token: tokenString, completion: { user in
                        completion(user, nil)
                    })
                }
            }
        }
    }

    // MARK: - FetchFacebookProfile
	private func fetchFacebookProfile(token: String, completion: @escaping ((SocialUser?) -> Void)) {
		let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, email"])
		request.start { connection, result, error in
			if let error = error {
				print("Failed to get Facebook profile: \(error.localizedDescription)")
				DispatchQueue.main.async {
					completion(nil)
				}
				return
			}

			if let userInfo = result as? [String: Any] {
				let socialMediaId = userInfo["id"] as? String
				let firstName = userInfo["first_name"] as? String
				let lastName = userInfo["last_name"] as? String
				let email = userInfo["email"] as? String
				let user = SocialUser(id: socialMediaId, firstName: firstName, lastName: lastName, email: email, profileImageUrl: nil)
				DispatchQueue.main.async {
					completion(user)
				}
			} else {
				DispatchQueue.main.async {
					completion(nil)
				}
			}
		}
	}
}
