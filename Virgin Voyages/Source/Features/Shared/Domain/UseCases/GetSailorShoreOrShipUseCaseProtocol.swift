//
//  GetSailorTypeUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 7.3.25.
//

protocol GetSailorTypeUseCaseProtocol {
    func execute() -> SailorType
}

final class GetSailorTypeUseCase: GetSailorTypeUseCaseProtocol {
    private let currentSailorManager : CurrentSailorManagerProtocol
    
    init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.currentSailorManager = currentSailorManager
    }
    
    func execute() -> SailorType {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			return .standard
		}

        return currentSailor.sailorType
    }
}
