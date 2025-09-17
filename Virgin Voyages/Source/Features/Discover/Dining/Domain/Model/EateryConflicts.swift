//
//  EateriesConflictsInput.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 27.11.24.
//

import Foundation

struct EateryConflicts {
    struct Details {
        struct PersonDetail {
            let personId: String
            let count: Int
        }
        
        let bookingStartDateTime: Int?
        let bookingActivityCode: String?
        let personDetails: [PersonDetail]
        let cancellableRestaurantExternalId: String?
        let cancellableAppointmentDateTime: Date?
        let swappableRestaurantExternalId: String?
        let swappableAppointmentDateTime: Date?
        let cancellableBookingLinkId: String?
    }
    
    let isSwapped: Bool
    let details: Details
    let type: String
}

extension EateryConflicts {
    static func map(from response: GetEateryConflictsResponse) -> EateryConflicts {
        let mappedPersonDetails = response.details?.personDetails?.map { detail in
            EateryConflicts.Details.PersonDetail(
                personId: detail.personId ?? "",
                count: detail.count ?? 0
            )
        } ?? []
        
        return EateryConflicts(
            isSwapped: response.isSwapped ?? false,
            details: EateryConflicts.Details(
                bookingStartDateTime: response.details?.bookingStartDateTime,
                bookingActivityCode: response.details?.bookingActivityCode,
                personDetails: mappedPersonDetails,
                cancellableRestaurantExternalId: response.details?.cancellableRestaurantExternalId,
                cancellableAppointmentDateTime: ((response.details?.cancellableAppointmentDateTime?.isEmpty) != nil)
				? Date.fromISOString(string: response.details?.cancellableAppointmentDateTime)
                : nil,
                swappableRestaurantExternalId: response.details?.swappableRestaurantExternalId,
                swappableAppointmentDateTime: ((response.details?.swappableAppointmentDateTime?.isEmpty) != nil)
                ? Date.fromISOString(string: response.details?.swappableAppointmentDateTime)
                : nil,
                cancellableBookingLinkId: response.details?.cancellableBookingLinkId
            ),
            type: response.type ?? ""
        )
    }
}

extension EateryConflicts {
	static func sample() -> EateryConflicts {
		return EateryConflicts(
			isSwapped: false,
			details: Details.sample(),
			type: "soft"
		)
	}
}

extension EateryConflicts.Details {
	static func sample() -> EateryConflicts.Details {
		return EateryConflicts.Details(
			bookingStartDateTime: 1234567890,
			bookingActivityCode: "ACT123",
			personDetails: [
				PersonDetail(personId: "1", count: 1),
				PersonDetail(personId: "2", count: 1)
			],
			cancellableRestaurantExternalId: "REST123",
			cancellableAppointmentDateTime: Date(),
			swappableRestaurantExternalId: "REST456",
			swappableAppointmentDateTime: Date(),
			cancellableBookingLinkId: "LINK123"
		)
	}
}

extension EateryConflicts {
	func copy(
		isSwapped: Bool? = nil,
		details: Details? = nil,
		type: String? = nil
	) -> EateryConflicts {
		return EateryConflicts(
			isSwapped: isSwapped ?? self.isSwapped,
			details: details ?? self.details,
			type: type ?? self.type
		)
	}
}

extension EateryConflicts.Details {
	func copy(
		bookingStartDateTime: Int? = nil,
		bookingActivityCode: String? = nil,
		personDetails: [PersonDetail]? = nil,
		cancellableRestaurantExternalId: String? = nil,
		cancellableAppointmentDateTime: Date? = nil,
		swappableRestaurantExternalId: String? = nil,
		swappableAppointmentDateTime: Date? = nil,
		cancellableBookingLinkId: String? = nil
	) -> EateryConflicts.Details {
		return EateryConflicts.Details(
			bookingStartDateTime: bookingStartDateTime ?? self.bookingStartDateTime,
			bookingActivityCode: bookingActivityCode ?? self.bookingActivityCode,
			personDetails: personDetails ?? self.personDetails,
			cancellableRestaurantExternalId: cancellableRestaurantExternalId ?? self.cancellableRestaurantExternalId,
			cancellableAppointmentDateTime: cancellableAppointmentDateTime ?? self.cancellableAppointmentDateTime,
			swappableRestaurantExternalId: swappableRestaurantExternalId ?? self.swappableRestaurantExternalId,
			swappableAppointmentDateTime: swappableAppointmentDateTime ?? self.swappableAppointmentDateTime,
			cancellableBookingLinkId: cancellableBookingLinkId ?? self.cancellableBookingLinkId
		)
	}
}
