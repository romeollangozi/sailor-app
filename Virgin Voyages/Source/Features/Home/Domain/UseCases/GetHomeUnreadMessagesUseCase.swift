//
//  GetHomeUnreadMessagesUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/29/25.
//

import Foundation

protocol GetHomeUnreadMessagesUseCaseProtocol: AnyObject {
    func execute() async throws -> HomeUnreadMessages
}

class GetHomeUnreadMessagesUseCase: GetHomeUnreadMessagesUseCaseProtocol {
    
    // MARK: - Properties
    private let homeUnreadMessagesRepository: HomeUnreadMessagesRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol


    // MARK: - Init
    init(homeUnreadMessagesRepository: HomeUnreadMessagesRepositoryProtocol = HomeUnreadMessagesRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.homeUnreadMessagesRepository = homeUnreadMessagesRepository
        self.currentSailorManager = currentSailorManager
    }
    
    // MARK: - Execute
    func execute() async throws -> HomeUnreadMessages {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        guard let homeUnreadMessages = try await homeUnreadMessagesRepository.getHomeUnreadMessages(voyageNumber: currentSailor.voyageNumber) else {
            throw VVDomainError.genericError
        }
        
        return homeUnreadMessages
        
    }
}
