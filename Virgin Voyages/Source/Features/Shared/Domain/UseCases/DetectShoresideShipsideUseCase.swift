//
//  DetectShoresideShipsideUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/27/24.
//

import Foundation

final class DetectShoresideShipsideUseCase {
    private let shipNetworkDetector: ShipNetworkDetectorProtocol
    private let lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol
    private let userShoreShipLocationEventsNotificationService: UserShoreShipLocationEventsNotificationService

    init(
        shipNetworkDetector: ShipNetworkDetectorProtocol = ShipNetworkDetector(),
        lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol = LastKnownSailorConnectionLocationRepository(),
        userShoreShipLocationEventsNotificationService: UserShoreShipLocationEventsNotificationService = .shared
    ) {
        self.shipNetworkDetector = shipNetworkDetector
        self.lastKnownSailorConnectionLocationRepository = lastKnownSailorConnectionLocationRepository
        self.userShoreShipLocationEventsNotificationService = userShoreShipLocationEventsNotificationService
    }

    func execute() async {
        let isShipNetworkReachable = await shipNetworkDetector.isShipNetworkReachable()
        await handleResult(isShipNetworkReachable: isShipNetworkReachable)
    }

    @MainActor
    private func handleResult(isShipNetworkReachable: Bool) {
        let previousLocation = getCurrentUserLocation()
        let newLocation: SailorLocation = isShipNetworkReachable ? .ship : .shore

        if hasTransitioned(from: previousLocation, to: newLocation) {
            userShoreShipLocationEventsNotificationService.publish(.userDidSwitchFromShoreToShip)
        }

        try? lastKnownSailorConnectionLocationRepository.updateSailorConnectionLocation(newLocation)
    }

    private func getCurrentUserLocation() -> SailorLocation {
        lastKnownSailorConnectionLocationRepository.fetchLastKnownSailorConnectionLocation()
    }

    private func hasTransitioned(from oldLocation: SailorLocation, to newLocation: SailorLocation) -> Bool {
        return oldLocation == .shore && newLocation == .ship
    }
}
