//
//  BoardingPassAppleWalletRepository.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/10/25.
//

import Foundation

protocol BoardingPassAppleWalletRepositoryProtocol {
    func getBoardingPassAppleWallet(reservationGuestId: String) async throws -> Data?
}

final class BoardingPassAppleWalletRepository: BoardingPassAppleWalletRepositoryProtocol {
    
    // MARK: - Properties
    private let netoworkService: NetworkServiceProtocol
    
    // MARK: - Init
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.netoworkService = networkService
    }
    
    // MARK: - Download file
    func getBoardingPassAppleWallet(reservationGuestId: String) async throws -> Data? {
        return try await netoworkService.getBoardingPassAppleWallet(reservationGuestId: reservationGuestId)
    }
    
}
