//
//  RequestPushNotificationPermissionsUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/19/24.
//

import UIKit
import Foundation

class RequestPushNotificationPermissionsUseCase {
    private let pushNotificationService: PushNotificationProviderProtocol

    init(pushNotificationService: PushNotificationProviderProtocol) {
		self.pushNotificationService = pushNotificationService
	}

	func execute() async {
        let authorizationStatus = await pushNotificationService.getCurrentAuthorizationStatus()
        
        switch authorizationStatus {
        case .notDetermined:
            await requestPushNotificationPermissions()
        case .denied, .authorized, .provisional, .ephemeral:
            return
        }
	}

	private func requestPushNotificationPermissions() async {
		await pushNotificationService.requestPushNotificationPermissions()
	}
}
