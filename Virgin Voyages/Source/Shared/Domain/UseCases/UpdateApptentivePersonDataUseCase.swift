//
//  UpdateApptentivePersonDataUseCase.swift
//  Virgin Voyages
//
//  Created by Codex on 9/5/25.
//

import Foundation

protocol UpdateApptentivePersonDataUseCaseProtocol {
    func execute()
}

final class UpdateApptentivePersonDataUseCase: UpdateApptentivePersonDataUseCaseProtocol {
    private let apptentive: ApptentiveServiceProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol

    init(apptentive: ApptentiveServiceProtocol = ApptentiveService.shared,
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.apptentive = apptentive
        self.currentSailorManager = currentSailorManager
    }

    func execute() {
        let sailor = currentSailorManager.getCurrentSailor()
        apptentive.setPersonData(bookingReference: sailor?.reservationNumber,
                                 voyageNumber: sailor?.voyageNumber)
    }
}
