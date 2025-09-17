//
//  CancelAddonUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 17.10.24.
//

import Foundation

protocol CancelAddonUseCaseProtocol {
    func cancelAddon(guests: [String], code: String, quantity: Int) async -> Result<Bool, VVDomainError>
}

class CancelAddonUseCase: CancelAddonUseCaseProtocol {
    
    // MARK: - Repository
    private var cancelAddonRepository: CancelAddonRepositoryProtocol
    
    // MARK: - Init
    init(cancelAddonRepository: CancelAddonRepositoryProtocol) {
        self.cancelAddonRepository = cancelAddonRepository
    }
    
    // MARK: - Cancel
    func cancelAddon(guests: [String], code: String, quantity: Int) async -> Result<Bool, VVDomainError> {
        return await cancelAddonRepository.execute(guestIds: guests, code: code, quantity: quantity)
    }
}
