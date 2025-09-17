//
//  ChatThreadsRepository.swift
//  Virgin Voyages
//
//  Created by TX on 13.2.25.
//

import Foundation

protocol ChatThreadsRepositoryProtocol {
    func getChatThreads(voyageNumber: String, sailorType: SailorType, reservationGuesID: String) async throws -> [ChatThread]
}

class ChatThreadsRepository: ChatThreadsRepositoryProtocol {
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func getChatThreads(voyageNumber: String, sailorType: SailorType, reservationGuesID: String) async throws -> [ChatThread] {
        let response = try await networkService.fetchChatThreads(voyageNumber: voyageNumber, sailorType:sailorType.stringValue, reservationGuestID: reservationGuesID)
		return response.items.map {
            $0.toDomain()
		}
    }
}
