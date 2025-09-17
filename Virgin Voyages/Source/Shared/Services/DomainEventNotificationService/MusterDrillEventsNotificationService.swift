//
//  MusterDrillEventsNotificationService.swift
//  Virgin Voyages
//
//  Created by TX on 8.4.25.
//

import Foundation

enum MusterDrillNotification: Hashable {
    case userDidFinishWatchingMusterDrill
    case shouldRestartMusterDrillVideo
    case shouldShowMusterDrill
    case shouldHideMusterDrill
    case shouldRefreshMusterDrill
    case homeViewDidAppear
}

final class MusterDrillEventsNotificationService: DomainNotificationService<MusterDrillNotification> {
    static let shared = MusterDrillEventsNotificationService()
}

