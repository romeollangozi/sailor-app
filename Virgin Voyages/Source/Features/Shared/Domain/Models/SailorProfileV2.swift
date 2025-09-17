//
//  SailorProfileV2.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 26.3.25.
//

import Foundation

enum SailorProfileV2ErrorState: String, Codable, Equatable {
	case voyageUpdate = "VOYAGE_UPDATE"
	case voyageCancelled = "RESERVATION_CANCELLED"
	case voyageNotFound = "VOYAGE_NOT_FOUND"
	case guestNotFound = "GUEST_NOT_FOUND"
	init?(rawValue: String) {
		switch rawValue {
		case SailorProfileV2ErrorState.voyageUpdate.rawValue:
			self = .voyageUpdate
		case SailorProfileV2ErrorState.voyageCancelled.rawValue:
			self = .voyageCancelled
		case SailorProfileV2ErrorState.voyageNotFound.rawValue:
			self = .voyageNotFound
		case SailorProfileV2ErrorState.guestNotFound.rawValue:
			self = .guestNotFound
		default:
			return nil
		}
	}
}

struct SailorProfileV2: Equatable {
    let userId: String
	let email: String
	let firstName: String
	let lastName: String
	let preferredName: String
	let genderCode: String
	let photoUrl: String
	let birthDate: String
	let citizenshipCountryCode: String
	let phoneCountryCode: String
	let phoneNumber: String
	let type: SailorType
	let typeCode: String
	let cabinNumber: String?
	let errorState: SailorProfileV2ErrorState?
	private let reservation: Reservation?
	let upcomingReservation: Reservation?
	let externalRefId: String?

    
    // TODO: Need to check if getting the upcomingReservation is correct to return here.
	func activeReservation() -> Reservation? {
		if reservation?.status == .cancelled {
			return upcomingReservation
		} else {
			return reservation
		}
	}

    struct Reservation: Equatable {
		let status: ReservationStatus
		let shipCode: String
		let shipName: String
		let isPassed: Bool
		let voyageId: String
		let voyageNumber: String
		let embarkDate: String
		let debarkDate: String
		let embarkDateTime: String
		let debarkDateTime: String
		let reservationId: String
		let reservationNumber: String
		let guestId: String
		let reservationGuestId: String
		let deckPlanUrl: String
		let itineraries: [Itinerary]
    }
    
    struct Itinerary: Equatable {
		let dayType: String
		let dayNumber: Int
		let date: Date
		let dayOfWeekCode: String
		let dayOfWeek: String
		let dayOfMonth: String
		let isPortDay: Bool
		let portCode: String
		let portName: String
    }

	init(userId: String,
		 email: String,
		 firstName: String,
		 lastName: String,
		 preferredName: String,
		 genderCode: String,
		 photoUrl: String,
		 birthDate: String,
		 citizenshipCountryCode: String,
		 phoneCountryCode: String,
		 phoneNumber: String,
		 type: SailorType,
		 typeCode: String,
		 cabinNumber: String?,
		 errorState: SailorProfileV2ErrorState?,
		 reservation: Reservation?,
		 upcomingReservation: Reservation?,
		 externalRefId: String?) {
		self.userId = userId
		self.email = email
		self.firstName = firstName
		self.lastName = lastName
		self.preferredName = preferredName
		self.genderCode = genderCode
		self.photoUrl = photoUrl
		self.birthDate = birthDate
		self.citizenshipCountryCode = citizenshipCountryCode
		self.phoneCountryCode = phoneCountryCode
		self.phoneNumber = phoneNumber
		self.type = type
		self.typeCode = typeCode
		self.cabinNumber = cabinNumber
		self.errorState = errorState
		self.reservation = reservation
		self.upcomingReservation = upcomingReservation
		self.externalRefId = externalRefId
	}
}

extension SailorProfileV2 {
    static func empty() -> SailorProfileV2 {
        return SailorProfileV2(
            userId: "",
            email: "",
            firstName: "",
            lastName: "",
            preferredName: "",
            genderCode: "",
            photoUrl: "",
            birthDate: "",
            citizenshipCountryCode: "",
            phoneCountryCode: "",
            phoneNumber: "",
            type: .standard,
            typeCode: "",
			cabinNumber: "",
			errorState: nil,
            reservation: nil,
            upcomingReservation: nil,
			externalRefId: ""
        )
    }
	
	static func sample() -> SailorProfileV2 {
		return SailorProfileV2(
			userId: "5afd9af2-7df0-4ee6-b7f0-5dd9c8cc75d8",
			email: "Emil.LubowitzSC250323@yopmail.com",
			firstName: "Emil",
			lastName: "Lubowitz",
			preferredName: "Emil",
			genderCode: "X",
			photoUrl: "https://example.com/photo.jpg",
			birthDate: "1986-03-18",
			citizenshipCountryCode: "US",
			phoneCountryCode: "+1",
			phoneNumber: "1234567890",
			type: .standard,
			typeCode: "OTHER",
			cabinNumber: "8086Z",
			errorState: nil,
			reservation: Reservation(
				status: .confirmed,
				shipCode: "SC",
				shipName: "Scarlet Lady",
				isPassed: false,
				voyageId: "e078028d-2556-4024-9acb-3f9067ab0fd6",
				voyageNumber: "SC2503235NCZ",
				embarkDate: "2025-03-23",
				debarkDate: "2025-03-28",
				embarkDateTime: "2025-03-23T18:00:00",
				debarkDateTime: "2025-03-28T06:30:00",
				reservationId: "8760230a-09d4-4812-ae0c-028adb0629e2",
				reservationNumber: "1501983",
				guestId: "5307e35b-0f7f-43bc-a1f7-2b2d48fbdc61",
				reservationGuestId: "75543b23-f49a-4bd0-9555-3966939230be",
				deckPlanUrl: "",
				itineraries: [
					Itinerary(
						dayType: "Current",
						dayNumber: 1,
						date: ISO8601DateFormatter().date(from: "2025-03-23") ?? Date(),
						dayOfWeekCode: "S",
						dayOfWeek: "Sunday",
						dayOfMonth: "23",
						isPortDay: true,
						portCode: "MIA",
						portName: "Miami"
					)
				]
			),
			upcomingReservation: nil,
			externalRefId: ""
		)
	}
}

extension SailorProfileV2 {
	func copy(
		userId: String? = nil,
		email: String? = nil,
		firstName: String? = nil,
		lastName: String? = nil,
		preferredName: String? = nil,
		genderCode: String? = nil,
		photoUrl: String? = nil,
		birthDate: String? = nil,
		citizenshipCountryCode: String? = nil,
		phoneCountryCode: String? = nil,
		phoneNumber: String? = nil,
		type: SailorType? = nil,
		typeCode: String? = nil,
		cabinNumber: String? = nil,
		errorState: SailorProfileV2ErrorState? = nil,
		reservation: Reservation? = nil,
		upcomingReservation: Reservation? = nil,
		externalRefId: String? = nil
	) -> SailorProfileV2 {
		return SailorProfileV2(
			userId: userId ?? self.userId,
			email: email ?? self.email,
			firstName: firstName ?? self.firstName,
			lastName: lastName ?? self.lastName,
			preferredName: preferredName ?? self.preferredName,
			genderCode: genderCode ?? self.genderCode,
			photoUrl: photoUrl ?? self.photoUrl,
			birthDate: birthDate ?? self.birthDate,
			citizenshipCountryCode: citizenshipCountryCode ?? self.citizenshipCountryCode,
			phoneCountryCode: phoneCountryCode ?? self.phoneCountryCode,
			phoneNumber: phoneNumber ?? self.phoneNumber,
			type: type ?? self.type,
			typeCode: typeCode ?? self.typeCode,
			cabinNumber: cabinNumber ?? self.cabinNumber,
			errorState: errorState,
			reservation: reservation ?? self.reservation,
			upcomingReservation: upcomingReservation ?? self.upcomingReservation,
			externalRefId: externalRefId ?? self.externalRefId
		)
	}
}

extension SailorProfileV2.Reservation {
	static func sample() -> SailorProfileV2.Reservation {
		.init(
			status: .confirmed,
			shipCode: "SC",
			shipName: "Scarlet Lady",
			isPassed: false,
			voyageId: "e078028d-2556-4024-9acb-3f9067ab0fd6",
			voyageNumber: "SC2503235NCZ",
			embarkDate: "2025-03-23",
			debarkDate: "2025-03-28",
			embarkDateTime: "2025-03-23T18:00:00",
			debarkDateTime: "2025-03-28T06:30:00",
			reservationId: "8760230a-09d4-4812-ae0c-028adb0629e2",
			reservationNumber: "1501983",
			guestId: "5307e35b-0f7f-43bc-a1f7-2b2d48fbdc61",
			reservationGuestId: "75543b23-f49a-4bd0-9555-3966939230be",
			deckPlanUrl: "",
			itineraries: [
				.init(
					dayType: "Current",
					dayNumber: 1,
					date: ISO8601DateFormatter().date(from: "2025-03-23") ?? Date(),
					dayOfWeekCode: "S",
					dayOfWeek: "Sunday",
					dayOfMonth: "23",
					isPortDay: true,
					portCode: "MIA",
					portName: "Miami"
				)
			]
		)
	}
}

extension SailorProfileV2.Reservation {
	func copy(
		status: ReservationStatus? = nil,
		shipCode: String? = nil,
		shipName: String? = nil,
		isPassed: Bool? = nil,
		voyageId: String? = nil,
		voyageNumber: String? = nil,
		embarkDate: String? = nil,
		debarkDate: String? = nil,
		embarkDateTime: String? = nil,
		debarkDateTime: String? = nil,
		reservationId: String? = nil,
		reservationNumber: String? = nil,
		guestId: String? = nil,
		reservationGuestId: String? = nil,
		deckPlanUrl: String? = nil,
		itineraries: [SailorProfileV2.Itinerary]? = nil
	) -> SailorProfileV2.Reservation {
		return SailorProfileV2.Reservation(
			status: status ?? self.status,
			shipCode: shipCode ?? self.shipCode,
			shipName: shipName ?? self.shipName,
			isPassed: isPassed ?? self.isPassed,
			voyageId: voyageId ?? self.voyageId,
			voyageNumber: voyageNumber ?? self.voyageNumber,
			embarkDate: embarkDate ?? self.embarkDate,
			debarkDate: debarkDate ?? self.debarkDate,
			embarkDateTime: embarkDateTime ?? self.embarkDateTime,
			debarkDateTime: debarkDateTime ?? self.debarkDateTime,
			reservationId: reservationId ?? self.reservationId,
			reservationNumber: reservationNumber ?? self.reservationNumber,
			guestId: guestId ?? self.guestId,
			reservationGuestId: reservationGuestId ?? self.reservationGuestId,
			deckPlanUrl: deckPlanUrl ?? self.deckPlanUrl,
			itineraries: itineraries ?? self.itineraries
		)
	}
}

