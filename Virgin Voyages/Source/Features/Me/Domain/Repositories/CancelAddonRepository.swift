//
//  CancelAddonRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 16.10.24.
//

import Foundation

protocol CancelAddonRepositoryProtocol {
    // MARK: - Cancel addon method definition
    func execute(guestIds: [String], code: String, quantity: Int) async -> Result<Bool, VVDomainError>
}

class CancelAddonRepository: CancelAddonRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    // MARK: - Cancel addon
    func execute(guestIds: [String], code: String, quantity: Int) async -> Result<Bool, VVDomainError> {
        if let authentication = try? AuthenticationService.shared.currentSailor() {
            let reservation = authentication.reservation
            let apiResult = await networkService.cancelAddon(reservationNumber: reservation.reservationNumber, guestIds: guestIds, code: code, quantity: quantity)
            if let networkError = apiResult.error {
                return .failure(NetworkToVVDomainErrorMapper.map(from: networkError))
            }
            return .success(true)
        }
		return .failure(.unauthorized)
    }
}
