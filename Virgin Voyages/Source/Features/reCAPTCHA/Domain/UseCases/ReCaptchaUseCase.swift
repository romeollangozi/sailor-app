//
//  ReCaptchaUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 13.9.24.
//

import Foundation
import RecaptchaEnterprise

// MARK: - Typealias
public struct ReCaptchaResponse: Hashable {
    let status: Bool
    let token: String?
    let error: String?
    
    init(status: Bool, token: String? = nil, error: String? = nil) {
        self.status = status
        self.token = token
        self.error = error
    }
}

// MARK: - ReCaptchaUseCase Protocol
protocol ReCaptchaUseCaseProtocol {
    func execute(action: String) async -> ReCaptchaResponse
}

// MARK: - ReCaptchaUseCase
class ReCaptchaUseCase: ReCaptchaUseCaseProtocol {
    
    var recaptchaClient: RecaptchaEnterpriseSDK.RecaptchaClient?
    var recaptchaInitializationFailed: Bool
    
    init(recaptchaInitializationFailed: Bool = false) {
        
        self.recaptchaInitializationFailed = recaptchaInitializationFailed
        
        // Initialize Recaptcha Client
        Task {
            do {
                let info = Bundle.main.infoDictionary

                guard let site_key = info?["RECAPTCHA_SITE_KEY"] as? String else {
                    throw VVDomainError.error(title: "reCaptcha site key not found", message: "RECAPTCHA_SITE_KEY not found in Info.plist")
                }
                self.recaptchaClient = try await Recaptcha.fetchClient(withSiteKey: site_key)
            } catch let error as RecaptchaError {
                print("ReCaptchaUseCase - RecaptchaClient creation error: \(String(describing: error.errorMessage)).")
            } catch {
                print("ReCaptchaUseCase - RecaptchaClient creation error: \(String(describing: error)).")
            }
        }
    }
    
    func execute(action: String) async -> ReCaptchaResponse {
        
        let genericErrorString = "something went wrong"
        guard let recaptchaClient = self.recaptchaClient else {
            return ReCaptchaResponse(status: false, error: genericErrorString)
        }
        
        do {
            let token = try await recaptchaClient.execute(withAction: RecaptchaAction.custom(action))
            print("ReCaptchaUseCase verifyToken - Verified")
            return ReCaptchaResponse(status: true, token: token)
        } catch let error as RecaptchaError {
            print("ReCaptchaUseCase verifyToken - Error: ", error.errorMessage)
            return ReCaptchaResponse(status: false, error: error.errorMessage)
        } catch {
            return ReCaptchaResponse(status: false, error: genericErrorString)
        }
    }
}
