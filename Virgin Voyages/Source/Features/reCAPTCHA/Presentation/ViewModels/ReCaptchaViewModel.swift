//
//  ReCaptchaViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 13.9.24.
//

import Foundation
import SwiftUI

protocol ReCaptchaViewModelProtocol {
    var action: String { get }
    var reCaptchaStatus: ReCaptchaResponse { get set }
    var error: String? { get set }
    var isLoading: Bool { get set }
    func verifyToken()
}

@Observable class ReCaptchaViewModel: BaseViewModel, ReCaptchaViewModelProtocol {
    
    // MARK: - Properties
    var reCaptchaStatus: ReCaptchaResponse
    var error: String? = nil
    var isLoading: Bool = false
    var action: String
    private var recaptchaUseCase: ReCaptchaUseCaseProtocol
    
    // MARK: - Init
    init(action: String,
         recaptchaUseCase: ReCaptchaUseCaseProtocol = ReCaptchaUseCase(),
         reCaptchaStatus: ReCaptchaResponse = ReCaptchaResponse(status: false)
    ) {
        self.action = action
        self.recaptchaUseCase = recaptchaUseCase
        self.reCaptchaStatus = reCaptchaStatus
    }
    
    func verifyToken() {
        withAnimation {
            self.isLoading = true
        }
        
        Task {
            let result = await executeUseCase { [self] in
                await self.recaptchaUseCase.execute(action: action)
            }
            
            guard let result else { return }
            
            
            await executeOnMain {
                if let error = result.error {
                    print("ReCaptchaViewModel verifyToken - recaptchaUseCase error: ", error)
                    self.error = error
                    withAnimation {
                        reCaptchaStatus = result
                        isLoading = false
                    }
                } else {
                    error = nil
                    withAnimation {
                        reCaptchaStatus = result
                        isLoading = false
                    }
                }
            }
        }
    }
}
