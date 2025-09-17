//
//  GetSailorProfileV2UseCase.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 26.3.25.
//

import Foundation

protocol GetSailorProfileV2UseCasePotocol {
    func execute(reservationNumber: String?) async -> SailorProfileV2?
}

class GetSailorProfileV2UseCase: GetSailorProfileV2UseCasePotocol {
    let sailorsProfileRepository: SailorProfileV2RepositoryProtocol
    
    init(sailorsProfileRepository: SailorProfileV2RepositoryProtocol = SailorProfileV2Repository()) {
        self.sailorsProfileRepository = sailorsProfileRepository
    }
    
    func execute(reservationNumber: String? = nil) async -> SailorProfileV2? {
        try? await self.sailorsProfileRepository.getSailorProfile(reservationNumber: reservationNumber)
    }
}
