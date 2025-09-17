//
//  GetChatThreadMessagesUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 6.2.25.
//

enum VVMessengerError: VVError {
    case failedToFetchMessages
    case failedToSendMessage
}

protocol GetChatThreadMessagesUseCaseProtocol {
    func execute(threadId: String, pageSize: Int, anchor: Int?, title: String, type: ChatType) async throws -> ChatMessagesModel
}

final class GetChatThreadMessagesUseCase: GetChatThreadMessagesUseCaseProtocol {
    
    private let chatThreadMessagesRepository: ChatThreadMessagesRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
	private let sailorChatDataRepository: SailorChatDataRepositoryProtocol
	
    init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(), chatThreadMessagesRepository: ChatThreadMessagesRepositoryProtocol = ChatThreadMessagesRepository(), sailorChatDataRepository: SailorChatDataRepositoryProtocol = SailorChatDataRepository()) {
        self.chatThreadMessagesRepository = chatThreadMessagesRepository
        self.currentSailorManager = currentSailorManager
		self.sailorChatDataRepository = sailorChatDataRepository
    }
    
    func execute(threadId: String, pageSize: Int, anchor : Int?, title: String, type: ChatType) async throws -> ChatMessagesModel {
        
        do {
            guard let currentSailor = currentSailorManager.getCurrentSailor() else {
                throw VVDomainError.unauthorized
            }
		
        
            guard let sailorChatData = try await sailorChatDataRepository.getSailorChatData(voyageNumber: currentSailor.voyageNumber) else {
                return ChatMessagesModel.empty
            }
            
            // IF new chat is initiated, we send the .id from getChatSailorData as a threadID to the request.
            let threadID = threadId == "" ? sailorChatData.id.stringValue : threadId
            
            guard let result = try await chatThreadMessagesRepository.fetchChatThreadMessages(threadId: threadID,
                                                                                              voyageNumber: currentSailor.voyageNumber,
                                                                                              sailorId: sailorChatData.sailorIamUserId,
                                                                                              pageSize: pageSize,
                                                                                              anchor: anchor,
                                                                                              type: type)
            else {
                return ChatMessagesModel.empty
            }

            var  image = ""
			switch type {
			case .sailorServices, .sailor :
				image = "ServiceAvatarImage"
			case .rockStarAgent:
				image = "ServiceAvatarRockstarAgent"
			case .crew:
				image = ""
			}

            let headerSubtitle = type == .sailorServices ? "Sailor Services Chat" : "Crew Chat"
            
            return ChatMessagesModel(items: result.items, nextAnchor: result.nextAnchor, hasMore: result.hasMore, headerTitle: title.capitalized, headerSubtitle: headerSubtitle, sailiorImage: image)
        } catch {
            throw VVMessengerError.failedToFetchMessages
        }
    }
    
}


