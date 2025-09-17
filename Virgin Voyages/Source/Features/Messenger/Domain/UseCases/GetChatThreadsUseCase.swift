//
//  GetChatThreadsUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 3.2.25.
//

import Foundation

protocol GetChatThreadsUseCaseProtocol {
    func execute() async throws -> [ChatThread]
}

final class GetChatThreadsUseCase: GetChatThreadsUseCaseProtocol {
    private let repository: ChatThreadsRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    private let sailorDataRepository: SailorChatDataRepositoryProtocol
    
    init(repository: ChatThreadsRepositoryProtocol = ChatThreadsRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
         sailorDataRepository: SailorChatDataRepositoryProtocol = SailorChatDataRepository()) {
        
        self.repository = repository
        self.currentSailorManager = currentSailorManager
        self.sailorDataRepository = sailorDataRepository
    }
    
    func execute() async throws -> [ChatThread] {        
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        let voyageNumber = currentSailor.voyageNumber
        let sailorType = currentSailor.sailorType
        let reservationGuestID = currentSailor.reservationGuestId
        
        let threads = try await repository.getChatThreads(voyageNumber: voyageNumber, sailorType: sailorType, reservationGuesID: reservationGuestID)
        let sortedThreads = self.sortThreadsByID(threads)
        return sortedThreads
    }
    
    func sortThreadsByID(_ threads: [ChatThread]) -> [ChatThread] {
        return threads.sorted { (thread1, thread2) -> Bool in
            return thread1.id > thread2.id
        }
    }
}
