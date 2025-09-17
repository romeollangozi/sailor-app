//
//  SailorChatDataRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 15.2.25.
//

import Foundation

protocol SailorChatDataRepositoryProtocol {
    func getSailorChatData(voyageNumber: String) async throws -> SailorChatData?
}

final class SailorChatDataRepository: SailorChatDataRepositoryProtocol {

    private let networkService: NetworkServiceProtocol
    
	// MARK: - Create network service for executing zulip endpoints
	init(networkService: NetworkServiceProtocol = NetworkService.createZulipService()) {
        self.networkService = networkService
    }
    
    func getSailorChatData(voyageNumber: String) async throws -> SailorChatData? {
		let result = try await networkService.getSailorChatData(voyageNumber: voyageNumber)
		guard let sailorData = result else { return nil }
		return sailorData.toDomain()
    }
}
