//
//  GetUserApplicationStatusUseCase.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 21.11.24.
//

protocol GetUserApplicationStatusUseCaseProtocol {
    func execute() async throws -> UserApplicationStatus
}

final class GetUserApplicationStatusUseCase: GetUserApplicationStatusUseCaseProtocol {
	private let sailorsProfileRepository: SailorProfileV2RepositoryProtocol
    private let tokenManager: TokenManagerProtocol
    
    init(sailorsProfileRepository: SailorProfileV2RepositoryProtocol = SailorProfileV2Repository(),
         tokenManager: TokenManagerProtocol =  TokenManager()) {
        self.sailorsProfileRepository = sailorsProfileRepository
        self.tokenManager = tokenManager
    }
    
    func execute() async throws -> UserApplicationStatus {
        if(tokenManager.token == nil) {
            return .userLoggedOut
        }
        
        let reservation = try await sailorsProfileRepository.getSailorProfile()
        
        return reservation != nil ? .userLoggedInWithReservation : .userLoggedInWithoutReservation
    }
}

enum UserApplicationStatus {
    case userLoggedInWithReservation
    case userLoggedInWithoutReservation
    case userLoggedOut
}
