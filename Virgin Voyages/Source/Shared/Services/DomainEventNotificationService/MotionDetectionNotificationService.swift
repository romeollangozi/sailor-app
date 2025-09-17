//
//  MotionDetectionNotificationService.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/25/25.
//

import Foundation

enum MotionDetectionNotification: Hashable {
    case didDetectMotion
}

final class MotionDetectionNotificationService: DomainNotificationService<MotionDetectionNotification> {
    static let shared = MotionDetectionNotificationService()
}
