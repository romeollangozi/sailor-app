//
//  GetHomePageGeneralDataUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 12.3.25.
//

import Foundation

protocol GetHomePageDataUseCaseProtocol {
    func execute(forSailingMode: SailingMode) async throws -> HomePage
}

class GetHomePageDataUseCase: GetHomePageDataUseCaseProtocol {
    private let repository: HomePageRepositoryProtocol
    private let myVoyageRepository: MyVoyageRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol    

    init(repository: HomePageRepositoryProtocol = HomePageRepository(),
         myVoyageRepository: MyVoyageRepositoryProtocol = MyVoyageRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.repository = repository
        self.myVoyageRepository = myVoyageRepository
        self.currentSailorManager = currentSailorManager
    }
    
    func execute(forSailingMode: SailingMode) async throws -> HomePage {
        
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        let reservationNumber = currentSailor.reservationNumber
        let reservationGuestId = currentSailor.reservationGuestId
        
        var sailingModeValue = forSailingMode.stringValue
        if forSailingMode == .undefined {
            print("GetHomePageDataUseCase - SailingMode is undefined, call MyVoyageRepository : FetchMyVoyageStatus")
            guard let sailingMode = try await myVoyageRepository.fetchMyVoyageStatus(reservationNumber: reservationNumber, reservationGuestId: reservationGuestId) else {
                print("GetHomePageDataUseCase - MyVoyageRepository : FetchMyVoyageStatus is nil")
                throw VVDomainError.genericError
            }
            sailingModeValue = sailingMode.stringValue
        }
        if let response = try await repository.fetchHomePageData(reservationNumber: reservationNumber, reservationGuestId: reservationGuestId, sailingMode: sailingModeValue) {
            return response
        } else {
            throw VVDomainError.genericError
        }
    }
    
}
