//
//  GetBoardingPassAppleWalletUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/10/25.
//

import Foundation

protocol GetBoardingPassAppleWalletUseCaseProtocol: AnyObject {
    func execute(reservationGuestId: String) async throws -> Data
}

class GetBoardingPassAppleWalletUseCase: GetBoardingPassAppleWalletUseCaseProtocol {
    
    // MARK: - Properties
    private let boardingPassAppleWalletRepository: BoardingPassAppleWalletRepositoryProtocol
    
    // MARK: - Init
    init(boardingPassAppleWalletRepository: BoardingPassAppleWalletRepositoryProtocol = BoardingPassAppleWalletRepository()) {
        self.boardingPassAppleWalletRepository = boardingPassAppleWalletRepository
    }
    
    // MARK: - Download file
    func execute(reservationGuestId: String) async throws -> Data {
        
        guard let result = try await self.boardingPassAppleWalletRepository.getBoardingPassAppleWallet(reservationGuestId: reservationGuestId) else {
            throw VVDomainError.genericError
        }
        
        return result
    }
    
}
