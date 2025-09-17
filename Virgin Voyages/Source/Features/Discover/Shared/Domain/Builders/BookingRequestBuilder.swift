//
//  BookingRequestBuilder.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/5/25.
//

import Foundation

enum BookingRequestBuilderError: Error {
	case missingDetails
}

class BookingRequestBuilder {
	private var booking: ActivityBooking?
	private var reservationDetails: ReservationDetails?
    private var isPreCruise: Bool?


	func setBooking(_ booking: ActivityBooking?) -> Self {
		self.booking = booking
		return self
	}

	func setReservationDetails(_ reservationDetails: ReservationDetails) -> Self {
		self.reservationDetails = reservationDetails
		return self
	}
    
    func setIsPreCruise(_ setIsPreCruise: Bool) -> Self {
        self.isPreCruise = setIsPreCruise
        return self
    }

	func build() throws -> BookActivityRequestBody {
		guard let booking = booking, let reservationDetails = reservationDetails, let isPreCruise = isPreCruise else {
			throw BookingRequestBuilderError.missingDetails
		}
		return BookActivityRequestBody(isPayWithSavedCard: booking.payWithExistingCard,
									   activityCode: booking.activity.activityCode,
						loggedInReservationGuestId: reservationDetails.reservationGuestId,
						reservationNumber: reservationDetails.reservationNumber,
						isGift: false,
						personDetails: booking.sailors.map {
				  BookActivityRequestBody.PersonDetails(personId: $0.personId,
														reservationNumber: $0.reservationNumber,
														guestId: $0.guestId,
														status: $0.status)
			  },
						activitySlotCode: booking.slot.activitySlotCode,
						accessories: [],
						totalAmount: booking.activity.totalAmount,
						currencyCode: booking.activity.currencyCode,
						operationType: booking.operationType.stringValue,
                        bookableType: booking.bookableType.rawValue,
                        isPreCruise: isPreCruise,
						appointmentLinkId: booking.appointmentLinkId,
						categoryCode: booking.activity.categoryCode,
						shipCode: reservationDetails.shipCode,
						voyageNumber: reservationDetails.voyageNumber,
						startDate: booking.slot.startDate,
						endDate: booking.slot.endDate)
	}
}
