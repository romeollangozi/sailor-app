//
//  ReservationService.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 29.10.24.
//

import Foundation

struct CurrentSailor : Codable, Equatable {
	let errorState: SailorProfileV2ErrorState?
    let reservationId: String
    let guestId: String
    let reservationGuestId: String
    let voyageNumber: String
    let reservationNumber: String
    let voyageId: String
    let shipCode: String
    let embarkDate: String
    let debarkDate: String
    let startDateTime: String
    let endDateTime: String
    let shipName: String
	let guestTypeCode: String
	let sailorType: SailorType
    let deckPlanUrl: String
    let itineraryDays: [ItineraryDay]
    let cabinNumber: String?
	let externalRefId: String?
}


// MARK: - init(with errorState: SailorProfileV2ErrorState) with only error state

extension CurrentSailor {
    init(with errorState: SailorProfileV2ErrorState?) {
        self.errorState = errorState
        self.reservationId = ""
        self.guestId = ""
        self.reservationGuestId = ""
        self.voyageNumber = ""
        self.reservationNumber = ""
        self.voyageId = ""
        self.shipCode = ""
        self.embarkDate = ""
        self.debarkDate = ""
        self.startDateTime = ""
        self.endDateTime = ""
        self.shipName = ""
        self.guestTypeCode = ""
        self.sailorType = .standard
        self.deckPlanUrl = ""
        self.itineraryDays = []
        self.cabinNumber = nil
        self.externalRefId = nil
    }
}

// MARK: - init(with sailorType: SailorType) No error state && No reservation
extension CurrentSailor {
    init(with sailorType: SailorType = .standard) {
        self.errorState = nil
        self.reservationId = ""
        self.guestId = ""
        self.reservationGuestId = ""
        self.voyageNumber = ""
        self.reservationNumber = ""
        self.voyageId = ""
        self.shipCode = ""
        self.embarkDate = ""
        self.debarkDate = ""
        self.startDateTime = ""
        self.endDateTime = ""
        self.shipName = ""
        self.guestTypeCode = ""
        self.sailorType = .standard
        self.deckPlanUrl = ""
        self.itineraryDays = []
        self.cabinNumber = nil
        self.externalRefId = nil
    }
}

extension CurrentSailor {
	static func sample() -> CurrentSailor {
		CurrentSailor(
			errorState: nil,
			reservationId: "123456",
			guestId: "654321",
			reservationGuestId: "987654",
			voyageNumber: "VN001",
			reservationNumber: "RSV001",
			voyageId: "VJ001",
			shipCode: "SC001",
			embarkDate: "2024-12-28",
			debarkDate: "2025-01-05",
			startDateTime: "2024-12-28T16:00:00Z",
			endDateTime: "2025-01-05T08:00:00Z",
			shipName: "Tropical Dream",
			guestTypeCode: "VIP1",
            sailorType: .standard,
            deckPlanUrl: "",
			itineraryDays: [
				ItineraryDay(
					itineraryDay: 1,
					isSeaDay: false,
					portCode: "MIA",
					day: "Saturday",
					dayOfWeek: "S",
					dayOfMonth: "28",
					date: ISO8601DateFormatter().date(from: "2024-12-28T00:00:00Z")!,
					portName: "Miami"
				),
				ItineraryDay(
					itineraryDay: 2,
					isSeaDay: true,
					portCode: "",
					day: "Sunday",
					dayOfWeek: "S",
					dayOfMonth: "29",
					date: ISO8601DateFormatter().date(from: "2024-12-29T00:00:00Z")!,
					portName: ""
				),
				ItineraryDay(
					itineraryDay: 3,
					isSeaDay: false,
					portCode: "POP",
					day: "Monday",
					dayOfWeek: "M",
					dayOfMonth: "30",
					date: ISO8601DateFormatter().date(from: "2024-12-30T00:00:00Z")!,
					portName: "Puerto Plata"
				)
			],
            cabinNumber: "8086Z",
            externalRefId: nil
		)
	}
}

extension CurrentSailor {
    func copy(
        reservationId: String? = nil,
        guestId: String? = nil,
        reservationGuestId: String? = nil,
        voyageNumber: String? = nil,
        reservationNumber: String? = nil,
        voyageId: String? = nil,
        shipCode: String? = nil,
        embarkDate: String? = nil,
        debarkDate: String? = nil,
        startDateTime: String? = nil,
        endDateTime: String? = nil,
        shipName: String? = nil,
		guestTypeCode: String? = nil,
		sailorType: SailorType? = nil,
        deckPlanUrl: String? = nil,
        itineraryDays: [ItineraryDay]? = nil,
        cabinNumber: String? = nil,
		externalRefId: String? = nil
    ) -> CurrentSailor {
        return CurrentSailor(
			errorState: nil,
            reservationId: reservationId ?? self.reservationId,
            guestId: guestId ?? self.guestId,
            reservationGuestId: reservationGuestId ?? self.reservationGuestId,
            voyageNumber: voyageNumber ?? self.voyageNumber,
            reservationNumber: reservationNumber ?? self.reservationNumber,
            voyageId: voyageId ?? self.voyageId,
            shipCode: shipCode ?? self.shipCode,
            embarkDate: embarkDate ?? self.embarkDate,
            debarkDate: debarkDate ?? self.debarkDate,
            startDateTime: startDateTime ?? self.startDateTime,
            endDateTime: endDateTime ?? self.endDateTime,
            shipName: shipName ?? self.shipName,
			guestTypeCode: guestTypeCode ?? self.guestTypeCode,
			sailorType: sailorType ?? .standard,
            deckPlanUrl: deckPlanUrl ?? self.deckPlanUrl,
            itineraryDays: itineraryDays ?? self.itineraryDays,
            cabinNumber: cabinNumber ?? self.cabinNumber,
			externalRefId: externalRefId ?? self.externalRefId
        )
    }
}

extension CurrentSailor {
	static func empty() -> CurrentSailor {
		return CurrentSailor(
			errorState: nil,
			reservationId: "",
			guestId: "",
			reservationGuestId: "",
			voyageNumber: "",
			reservationNumber: "",
			voyageId: "",
			shipCode: "",
			embarkDate: "",
			debarkDate: "",
			startDateTime: "",
			endDateTime: "",
			shipName: "",
			guestTypeCode: "",
            sailorType: .standard,
            deckPlanUrl: "",
            itineraryDays: [],
            cabinNumber: "",
			externalRefId: ""
		)
	}
}

protocol CurrentSailorManagerProtocol {
    func getCurrentSailor() -> CurrentSailor?
	func deleteCurrentSailor()
    func setCurrentSailor(currentSailor: CurrentSailor) -> Bool
	func setCurrentSailorFromSailorProfile(sailor: SailorProfileV2) -> CurrentSailor?
}

extension UserDefaultsKey {
	static let currentSailor = UserDefaultsKey("CurrentSailor")
}

class CurrentSailorManager: CurrentSailorManagerProtocol {
    private let keyValueRepository: KeyValueRepositoryProtocol
	private let sailorsProfileRepository: SailorProfileV2RepositoryProtocol
	
    init(keyValueRepository: KeyValueRepositoryProtocol = UserDefaultsKeyValueRepository(),
		 sailorsProfileRepository: SailorProfileV2RepositoryProtocol = SailorProfileV2Repository()) {
        self.keyValueRepository = keyValueRepository
		self.sailorsProfileRepository = sailorsProfileRepository
    }
    
    func getCurrentSailor() -> CurrentSailor? {
        guard let result: CurrentSailor = keyValueRepository.getObject(key: .currentSailor) else {
			return nil
        }
        
        return result
    }

	func deleteCurrentSailor() {
		keyValueRepository.remove(key: .currentSailor)
	}

    func setCurrentSailor(currentSailor: CurrentSailor) -> Bool {
		do {
			try keyValueRepository.setObject(key: .currentSailor, value: currentSailor)
			return true
		} catch {
            print("CurrentSailorManager - setCurrentSailorFromSailorProfile : unable to set current sailor")
			return false
		}
    }
	
	func setCurrentSailorFromSailorProfile(sailor: SailorProfileV2) -> CurrentSailor? {
		let currentSailor = createCurrentSailorFromSailorProfile(sailor)
        let didSet = setCurrentSailor(currentSailor: currentSailor)
        if didSet {
            return currentSailor
        } else {
            return nil
        }
	}

	private func createCurrentSailorFromSailorProfile(_ sailorProfile: SailorProfileV2) -> CurrentSailor {
		guard let reservation = sailorProfile.activeReservation() else {
			if sailorProfile.errorState == .voyageCancelled || sailorProfile.errorState == .voyageNotFound {
                return CurrentSailor(with: sailorProfile.errorState)
			} else {
                return CurrentSailor(with: sailorProfile.type)
			}
		}
		
		let itineraryDays = reservation.itineraries.map {
			ItineraryDay(
				itineraryDay: $0.dayNumber,
				isSeaDay: !$0.isPortDay,
				portCode: $0.portCode,
				day: $0.dayOfWeek,
				dayOfWeek: $0.dayOfWeekCode,
				dayOfMonth: $0.dayOfMonth,
				date: $0.date,
				portName: $0.portName
			)
		}
		
		return CurrentSailor(
            errorState: sailorProfile.errorState,
            reservationId: reservation.reservationId,
            guestId: reservation.guestId,
            reservationGuestId: reservation.reservationGuestId,
            voyageNumber: reservation.voyageNumber,
            reservationNumber: reservation.reservationNumber,
            voyageId: reservation.voyageId,
            shipCode: reservation.shipCode,
            embarkDate: reservation.embarkDate,
            debarkDate: reservation.debarkDate,
            startDateTime: reservation.embarkDateTime,
            endDateTime: reservation.debarkDateTime,
            shipName: reservation.shipName,
            guestTypeCode: sailorProfile.typeCode,
            sailorType: sailorProfile.type,
            deckPlanUrl: reservation.deckPlanUrl,
            itineraryDays: itineraryDays,
            cabinNumber: sailorProfile.cabinNumber,
            externalRefId: sailorProfile.externalRefId
        )

    }
}
