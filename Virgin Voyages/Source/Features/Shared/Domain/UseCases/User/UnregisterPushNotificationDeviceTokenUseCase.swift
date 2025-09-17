//
//  UnregisterDeviceTokenUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 3.12.24.
//

import Foundation

protocol UnregisterPushNotificationDeviceTokenUseCaseProtocol {
    func execute() async -> Bool
}

class UnregisterPushNotificationDeviceTokenUseCase: UnregisterPushNotificationDeviceTokenUseCaseProtocol {
    
    private let deviceTokenRepository: PushNotificationDeviceTokenRepositoryProtocol
    
    init(deviceTokenRepository: PushNotificationDeviceTokenRepositoryProtocol = PushNotificationDeviceTokenRepository()) {
        self.deviceTokenRepository = deviceTokenRepository
    }
    
    func execute() async -> Bool {
        await deviceTokenRepository.unregisterDeviceTokenForPushNotifications()
    }
}
