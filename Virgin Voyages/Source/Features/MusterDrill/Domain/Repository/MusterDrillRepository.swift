//
//  MusterDrill.swift
//  Virgin Voyages
//
//  Created by TX on 7.4.25.
//

import Foundation

protocol MusterDrillRepositoryProtocol {
    func fetchMusterDrillContent(shipcode: String, guestId: String) async throws -> MusterDrillContent?
    func markVideoWatched(shipcode: String, cabinNumber: String, reservationGuestId: String) async throws
}

final class MusterDrillRepository: MusterDrillRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private var musterDrillEventsNotificationService: MusterDrillEventsNotificationService

    init(networkService: NetworkServiceProtocol = NetworkService.create(),
         musterDrillEventsNotificationService: MusterDrillEventsNotificationService = .shared
    ) {
        self.networkService = networkService
        self.musterDrillEventsNotificationService = musterDrillEventsNotificationService
    }

    func fetchMusterDrillContent(shipcode: String, guestId: String) async throws -> MusterDrillContent? {
        let response = try await networkService.getMusterDrillContent(shipcode: shipcode, reservationGuestId: guestId)
        return response?.toDomain()
    }
    
    func markVideoWatched(shipcode: String, cabinNumber: String, reservationGuestId: String) async throws {
        _ = try await networkService.markMusterDrillVideoAsWatched(shipcode: shipcode, cabinNumber: cabinNumber, reservationGuestId: reservationGuestId)
    }
}
