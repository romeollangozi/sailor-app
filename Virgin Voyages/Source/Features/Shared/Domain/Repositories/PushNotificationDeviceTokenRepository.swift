//
//  PushNotificationDeviceTokenRepository.swift
//  Virgin Voyages
//
//  Created by TX on 21.11.24.
//

import Foundation
import UIKit


protocol PushNotificationDeviceTokenRepositoryProtocol {
    func registerDeviceTokenForPushNotifications() async -> Bool
    func unregisterDeviceTokenForPushNotifications() async -> Bool
}

class PushNotificationDeviceTokenRepository: PushNotificationDeviceTokenRepositoryProtocol {
    
    // MARK: - Properties
    private let networkService: NetworkServiceProtocol
    private let pushNotificationDeviceTokenManager: PushNotificationDeviceTokenManagerProtocol

    // MARK: - Init
    init(
		networkService: NetworkServiceProtocol = NetworkService.create(),
		pushNotificationDeviceTokenManager: PushNotificationDeviceTokenManagerProtocol = PushNotificationDeviceTokenManager()
	) {
        self.networkService = networkService
        self.pushNotificationDeviceTokenManager = pushNotificationDeviceTokenManager
    }
    
    func registerDeviceTokenForPushNotifications() async -> Bool {
        let deviceToken = self.pushNotificationDeviceTokenManager.getDeviceToken()
        guard !deviceToken.isEmpty else {
            print("PushNotificationDeviceTokenRepository - registerDeviceTokenForPushNotifications - Error: Device token is empty")
            return false
        }
        
        let deviceID = getVendorDeviceID()
        guard !deviceID.isEmpty else {
            print("PushNotificationDeviceTokenRepository - registerDeviceTokenForPushNotifications - Error: getVendorDeviceID is empty")
            return false
        }

        let requestInput = RegisterUserDeviceTokenBody(DeviceID: deviceID , FireBaseToken: deviceToken)
        do {
            let result = try await self.networkService.registerDeviceTokenForPushNotifications(input: requestInput)         
            return true

        } catch {
            print("DeviceTokenRepository - registerDeviceTokenForPushNotifications - Domain error: ", error)
            return false
        }
    }
    
    func unregisterDeviceTokenForPushNotifications() async -> Bool {
        let deviceID = getVendorDeviceID()
        guard !deviceID.isEmpty else { return false }

        // Unregister token 
        let requestInput = UnregisterUserDeviceTokenBody(DeviceID: deviceID)
        let result = await self.networkService.unregisterDeviceTokenForPushNotifications(input: requestInput)
        if let error = result.error {
            let domainError = NetworkToVVDomainErrorMapper.map(from: error)
            print("DeviceTokenRepository - unregisterDeviceTokenForPushNotifications - Domain error: ", domainError)
            return false
        }

        // Clear token locally
        self.pushNotificationDeviceTokenManager.clearDeviceToken()
        return true
    }
    
    private func getVendorDeviceID() -> String {
        return (UIDevice.current.identifierForVendor?.uuidString).value
    }
}
