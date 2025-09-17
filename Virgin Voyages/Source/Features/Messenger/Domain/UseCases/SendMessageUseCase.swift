//
//  SendMessageUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 20.2.25.
//

protocol SendMessageUseCaseProtocol {
    func execute(message: String, chatType: ChatType, to: String?) async throws -> SendMessage
}

class SendMessageUseCase: SendMessageUseCaseProtocol {

	private let sendMessageRepository: SendMessageRepositoryProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol
	private let sailorChatDataRepository: SailorChatDataRepositoryProtocol
	
	init(sendMessageRepository: SendMessageRepositoryProtocol = SendMessageRepository(),
		 currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		 sailorChatDataRepository: SailorChatDataRepositoryProtocol = SailorChatDataRepository()) {
		self.sendMessageRepository = sendMessageRepository
		self.currentSailorManager = currentSailorManager
		self.sailorChatDataRepository = sailorChatDataRepository
	}

    func execute(message: String, chatType: ChatType, to: String?) async throws -> SendMessage {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

        if chatType == .sailorServices {

            guard let sailorChatData = try await sailorChatDataRepository.getSailorChatData(voyageNumber: currentSailor.voyageNumber) else {
                return SendMessage.empty()
            }

            guard let result = try await sendMessageRepository.sendMessage(queueId: sailorChatData.id.stringValue, voyageNumber: currentSailor.voyageNumber, message: message) else {
                return SendMessage.empty()
            }

            return result
        } else {
            guard let result = try await sendMessageRepository.sendCrewMessage(to: to.value, voyageNumber: currentSailor.voyageNumber, message: message) else {
                return SendMessage.empty()
            }

            return result
        }
	}
}
