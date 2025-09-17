//
//  RegisterDeviceTokenUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 21.11.24.
//

import Foundation

protocol RegisterDeviceTokenUseCaseProtocol {
    func execute() async -> Bool
}

class RegisterDeviceTokenUseCase: RegisterDeviceTokenUseCaseProtocol {

	private let authenticationService: AuthenticationServiceProtocol
    private let deviceTokenRepository: PushNotificationDeviceTokenRepositoryProtocol
    
    init(
		authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared,
		deviceTokenRepository: PushNotificationDeviceTokenRepositoryProtocol = PushNotificationDeviceTokenRepository()
	) {
		self.authenticationService = authenticationService
        self.deviceTokenRepository = deviceTokenRepository
    }
    
    func execute() async -> Bool {
		guard authenticationService.isLoggedIn() else {
            print("RegisterDeviceTokenUseCase - Error: User is not logged in")
			return false
		}
        return await deviceTokenRepository.registerDeviceTokenForPushNotifications()
    }
}
