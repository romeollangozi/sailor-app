//
//  DeviceTokenManager.swift
//  Virgin Voyages
//
//  Created by TX on 21.11.24.
//

import Foundation

protocol PushNotificationDeviceTokenManagerProtocol {
    func getDeviceToken() -> String
    func setDeviceToken(token: String)
    func clearDeviceToken() 
}

enum PushNotificationDeviceTokenKeys {
    static let firebaseDeviceToken = "firebaseToken"
}

class PushNotificationDeviceTokenManager: PushNotificationDeviceTokenManagerProtocol {
    private let keyValueRepository: KeyValueRepositoryProtocol
    
    init(keyValueRepository: KeyValueRepositoryProtocol = UserDefaultsKeyValueRepository()) {
        self.keyValueRepository = keyValueRepository
    }
    
    func getDeviceToken() -> String {
        guard let deviceToken: String = keyValueRepository.get(key: PushNotificationDeviceTokenKeys.firebaseDeviceToken) else { return "" }
        return deviceToken
    }
    
    func setDeviceToken(token: String) {
        keyValueRepository.set(key: PushNotificationDeviceTokenKeys.firebaseDeviceToken, value: token)
    }
    
    func clearDeviceToken() {
        keyValueRepository.remove(key: PushNotificationDeviceTokenKeys.firebaseDeviceToken)
    }
}
