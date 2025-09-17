//
//  SendMessageRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 20.2.25.
//


protocol SendMessageRepositoryProtocol {
	func sendMessage(queueId: String, voyageNumber: String, message: String) async throws -> SendMessage?
    func sendCrewMessage(to: String, voyageNumber: String, message: String) async throws -> SendMessage?
}

final class SendMessageRepository: SendMessageRepositoryProtocol {

	private let networkService: NetworkServiceProtocol

	// MARK: - Create network service for executing zulip endpoints
	init(networkService: NetworkServiceProtocol = NetworkService.createZulipService()) {
		self.networkService = networkService
	}

	func sendMessage(queueId: String, voyageNumber: String, message: String) async throws -> SendMessage? {
		guard let result = try await networkService.sendMessage(queueId: queueId, voyageNumber: voyageNumber, content: message) else {
			return nil
		}
		return result.toDomain()
	}
    
    func sendCrewMessage(to: String, voyageNumber: String, message: String) async throws -> SendMessage? {
        guard let result = try await networkService.sendCrewMessage(
            input: .init(
                to: to,
                voyageNumber: voyageNumber,
                content: message,
                is_send_notification: "true",
                type: "private")
        ) else {
            return nil
        }
        return result.toDomain()

    }
}
