//
//  DeleteAllNotificationsRepository.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 1.5.25.
//

import Foundation

protocol DeleteAllNotificationsRepositoryProtocol {
    func deleteAllNotifications(reservationGuestId: String, voyageNumber: String) async throws -> EmptyResponse?
}

final class DeleteAllNotificationsRepository: DeleteAllNotificationsRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func deleteAllNotifications(reservationGuestId: String, voyageNumber: String) async throws -> EmptyResponse? {

        guard let response = try await networkService.deleteAllNotifications(reservationGuestId: reservationGuestId, voyageNumber: voyageNumber) else { return nil }
        
        return response
    }
}

