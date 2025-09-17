//
//  MockCurrentSailorManager.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 15.11.24.
//

import Foundation
@testable import Virgin_Voyages

class MockCurrentSailorManager: CurrentSailorManagerProtocol {

	func deleteCurrentSailor() {
	}
	
    var setCurrentSailorCalled = false
    var mockSetResult = true
    var lastSailor: CurrentSailor?
	var mockSailorProfile: SailorProfileV2? = nil
	
	init(lastSailor: CurrentSailor? = nil, setCurrentSailorCalled: Bool = false, mockSetResult: Bool = true) {
		self.setCurrentSailorCalled = setCurrentSailorCalled
		self.mockSetResult = mockSetResult
		self.lastSailor = lastSailor
	}
    
    func getCurrentSailor() -> Virgin_Voyages.CurrentSailor? {
		return lastSailor ?? CurrentSailor.empty()
    }
	
	func setCurrentSailorFromSailorProfile(sailor: Virgin_Voyages.SailorProfileV2) -> CurrentSailor? {
		mockSailorProfile = sailor
        return currentSailorFromSailorProfile(sailorProfile: sailor)
	}
	
    func setCurrentSailor(currentSailor: CurrentSailor) -> Bool {
        setCurrentSailorCalled = true
        lastSailor = currentSailor
        return mockSetResult
    }
	
    
    func currentSailorFromSailorProfile(sailorProfile: SailorProfileV2) -> CurrentSailor{
        let emptyReservation = SailorProfileV2.Reservation.sample()
        return CurrentSailor(
            errorState: sailorProfile.errorState,
            reservationId: emptyReservation.reservationId,
            guestId: emptyReservation.guestId,
            reservationGuestId: emptyReservation.reservationGuestId,
            voyageNumber: emptyReservation.voyageNumber,
            reservationNumber: emptyReservation.reservationNumber,
            voyageId: emptyReservation.voyageId,
            shipCode: emptyReservation.shipCode,
            embarkDate: emptyReservation.embarkDate,
            debarkDate: emptyReservation.debarkDate,
            startDateTime: emptyReservation.embarkDateTime,
            endDateTime: emptyReservation.debarkDateTime,
            shipName: emptyReservation.shipName,
            guestTypeCode: sailorProfile.typeCode,
            sailorType: sailorProfile.type,
            deckPlanUrl: emptyReservation.deckPlanUrl,
            itineraryDays: [],
            cabinNumber: sailorProfile.cabinNumber,
            externalRefId: sailorProfile.externalRefId
        )

    }
}
