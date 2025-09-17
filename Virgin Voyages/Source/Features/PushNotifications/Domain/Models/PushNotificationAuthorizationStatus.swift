//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 7.11.24.
//

import Foundation
import UserNotifications

enum PushNotificationAuthorizationStatus {
    case notDetermined
    case denied
    case authorized
    case provisional
    case ephemeral
}

extension PushNotificationAuthorizationStatus {
    init(from authorizationStatus: UNAuthorizationStatus) {
            switch authorizationStatus {
            case .notDetermined:
                self = .notDetermined
            case .denied:
                self = .denied
            case .authorized:
                self = .authorized
            case .provisional:
                self = .provisional
            case .ephemeral:
                self = .ephemeral
            @unknown default:
                self = .notDetermined
            }
        }
}

