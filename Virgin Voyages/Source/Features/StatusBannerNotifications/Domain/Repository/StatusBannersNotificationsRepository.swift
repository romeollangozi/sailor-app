//
//  StatusBannersNotificationsRepository.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/29/25.
//

import Foundation

protocol StatusBannersNotificationsRepositoryProtocol {
    func getStatusBannersNotifications(voyageNumber: String) async throws -> StatusBannersNotifications?
    func deleteOneNotification(notificationId: String, voyageNumber: String) async throws -> EmptyResponse?
}

final class StatusBannersNotificationsRepository: StatusBannersNotificationsRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func getStatusBannersNotifications(voyageNumber: String) async throws -> StatusBannersNotifications? {
        
        let response = try await networkService.getStatusBannerNotifications(voyageNumber: voyageNumber)
        return response?.toDomain()
    }
    
    func deleteOneNotification(notificationId: String, voyageNumber: String) async throws -> EmptyResponse? {
        
        let response = try await networkService.deleteOneNotification(notificationId: notificationId,
                                                                      voyageNumber: voyageNumber)
        return response
    }
    
}
