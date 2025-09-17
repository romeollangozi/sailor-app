//
//  SavePushNotificationDeviceTokenUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 21.11.24.
//

import Foundation

protocol SavePushNotificationDeviceTokenUseCaseProtocol {
    func execute(token: String)
}

class SavePushNotificationDeviceTokenUseCase: SavePushNotificationDeviceTokenUseCaseProtocol {
    private let pushNotificationDeviceTokenManager: PushNotificationDeviceTokenManagerProtocol

    init(pushNotificationDeviceTokenManager: PushNotificationDeviceTokenManagerProtocol = PushNotificationDeviceTokenManager()) {
        self.pushNotificationDeviceTokenManager = pushNotificationDeviceTokenManager
    }

    func execute(token: String) {
		pushNotificationDeviceTokenManager.setDeviceToken(token: token)
    }
}
