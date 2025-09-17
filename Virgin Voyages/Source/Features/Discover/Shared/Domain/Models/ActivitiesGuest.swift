//
//  ActivitiesGuest.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/14/24.
//

import Foundation

enum SailorState {
	case selected
	case unselected
	case hardClash
	case softClash
	case booked
}

class ActivitiesGuest {
	let guestId: String
	let firstName: String
	let lastName: String
	let genderCode: String
	let email: String
	let guestName: String
	let isVip: Bool
	let age: Int
	let reservationGuestId: String
	let reservationNumber: String
	let profileImageUrl: String
	let guestTypeCode: String
	let isCabinMate: Bool
	var originalSailorState: SailorState = .unselected
	var sailorState: SailorState = .unselected
	
	var status: String? {
		if originalSailorState == .booked {
			if sailorState == .unselected {
				return "CANCELLED"
			}
			if sailorState == .selected || sailorState == .booked {
				return "CONFIRMED"
			}
			return nil
		}
		return nil
	}

	init(
		guestId: String,
		firstName: String,
		lastName: String,
		genderCode: String,
		email: String,
		guestName: String,
		isVip: Bool,
		age: Int,
		reservationGuestId: String,
		reservationNumber: String,
		profileImageUrl: String,
		guestTypeCode: String,
		isCabinMate: Bool
	) {
		self.guestId = guestId
		self.firstName = firstName
		self.lastName = lastName
		self.genderCode = genderCode
		self.email = email
		self.guestName = guestName
		self.isVip = isVip
		self.age = age
		self.reservationGuestId = reservationGuestId
		self.reservationNumber = reservationNumber
		self.profileImageUrl = profileImageUrl
		self.guestTypeCode = guestTypeCode
		self.isCabinMate = isCabinMate
	}

    static func mapFrom(input: GetActivitiesGuestListResponse.Guest) -> ActivitiesGuest {
        return ActivitiesGuest(guestId: input.guestId.value,
							   firstName: input.firstName.value,
							   lastName: input.lastName.value,
							   genderCode: input.genderCode.value,
							   email: input.email.value,
							   guestName: input.guestName.value,
							   isVip: input.isVip.value,
							   age: input.age.value,
							   reservationGuestId: input.reservationGuestId.value,
							   reservationNumber: input.reservationNumber.value,
							   profileImageUrl: input.profileImageUrl.value,
							   guestTypeCode: input.guestTypeCode.value,
							   isCabinMate: input.isCabinMate.value)
    }
}

extension ActivitiesGuest: SailorPickerSailorViewModelProtocol {

	var id: String {
		return guestId
	}

	var photoURL: URL? {
		return URL(string: profileImageUrl)
	}

	var displayName: String {
		return firstName
	}

    var isLessThan21YearsOld: Bool {
        return abs(age) < 21
    }
    
	static func == (lhs: ActivitiesGuest, rhs: ActivitiesGuest) -> Bool {
		lhs.guestId == rhs.guestId
	}
    
}

extension ActivitiesGuest: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(guestId)
	}
}

extension Array where Element == ActivitiesGuest {
    func prioritizedGuestList(withId targetId: String) -> [ActivitiesGuest] {
        return self.sorted { $0.guestId == targetId && $1.guestId != targetId }
    }
}

extension Array where Element == ActivitiesGuest {
	func filterByReservationGuestIds(_ reservationGuestIds: [String]) -> [ActivitiesGuest] {
		return self.filter { reservationGuestIds.contains($0.reservationGuestId) }
	}
}


extension Array where Element == ActivitiesGuest {
    
    func onlyCabinMates() -> [ActivitiesGuest] {
        return self.filter({ x  in x.isCabinMate == true})
    }
    
    func makeCurrectSailorCabinMateWithSelf(reservationGuestId: String) -> [ActivitiesGuest] {
        return self.map({x in .init(guestId: x.guestId,
                                    firstName: reservationGuestId == x.reservationGuestId ? "You" : x.firstName,
                                    lastName: x.lastName,
                                    genderCode: x.genderCode,
                                    email: x.email,
                                    guestName: x.guestName,
                                    isVip: x.isVip,
                                    age: x.age,
                                    reservationGuestId: x.reservationGuestId,
                                    reservationNumber: x.reservationNumber,
                                    profileImageUrl: x.profileImageUrl,
                                    guestTypeCode: x.guestTypeCode,
                                    isCabinMate: x.isCabinMate || x.reservationGuestId == reservationGuestId)})
    }
}

extension ActivitiesGuest {
	static func sample() -> ActivitiesGuest {
		return ActivitiesGuest(
			guestId: "sampleGuestId",
			firstName: "John",
			lastName: "Doe",
			genderCode: "M",
			email: "john.doe@example.com",
			guestName: "John Doe",
			isVip: false,
			age: 30,
			reservationGuestId: "sampleReservationGuestId",
			reservationNumber: "123456",
			profileImageUrl: "https://example.com/profile.jpg",
			guestTypeCode: "ADULT",
			isCabinMate: false
		)
	}
}

extension ActivitiesGuest {
	func copy(
		guestId: String? = nil,
		firstName: String? = nil,
		lastName: String? = nil,
		genderCode: String? = nil,
		email: String? = nil,
		guestName: String? = nil,
		isVip: Bool? = nil,
		age: Int? = nil,
		reservationGuestId: String? = nil,
		reservationNumber: String? = nil,
		profileImageUrl: String? = nil,
		guestTypeCode: String? = nil,
		isCabinMate: Bool? = nil,
		originalSailorState: SailorState? = nil,
		sailorState: SailorState? = nil
	) -> ActivitiesGuest {
		return ActivitiesGuest(
			guestId: guestId ?? self.guestId,
			firstName: firstName ?? self.firstName,
			lastName: lastName ?? self.lastName,
			genderCode: genderCode ?? self.genderCode,
			email: email ?? self.email,
			guestName: guestName ?? self.guestName,
			isVip: isVip ?? self.isVip,
			age: age ?? self.age,
			reservationGuestId: reservationGuestId ?? self.reservationGuestId,
			reservationNumber: reservationNumber ?? self.reservationNumber,
			profileImageUrl: profileImageUrl ?? self.profileImageUrl,
			guestTypeCode: guestTypeCode ?? self.guestTypeCode,
			isCabinMate: isCabinMate ?? self.isCabinMate
		).apply {
		   $0.originalSailorState = originalSailorState ?? self.originalSailorState
		   $0.sailorState = sailorState ?? self.sailorState
		}
	}
}

private extension ActivitiesGuest {
	func apply(_ changes: (ActivitiesGuest) -> Void) -> ActivitiesGuest {
		changes(self)
		return self
	}
}
