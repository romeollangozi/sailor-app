//
//  HomeUnreadMessagesRepository.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/29/25.
//

import Foundation

protocol HomeUnreadMessagesRepositoryProtocol {
    func getHomeUnreadMessages(voyageNumber: String) async throws -> HomeUnreadMessages?
}

final class HomeUnreadMessagesRepository: HomeUnreadMessagesRepositoryProtocol {
    
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func getHomeUnreadMessages(voyageNumber: String) async throws -> HomeUnreadMessages? {
        if let response = try await networkService.getHomeUnreadMessages(voyageNumber: voyageNumber) {
            return response.toDomain()
        } else {
            return nil
        }
    }
    
}
