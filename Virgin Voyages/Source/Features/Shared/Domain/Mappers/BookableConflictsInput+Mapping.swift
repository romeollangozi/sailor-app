//
//  BookableConflictsRequestBody+Mapping.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 11.3.25.
//


extension BookableConflictsInput {
	func toNetworkDTO() -> BookableConflictsRequestBody {
		return BookableConflictsRequestBody(sailors: self.sailors.map({BookableConflictsRequestBody.Sailor(reservationNumber: $0.reservationNumber, reservationGuestId: $0.reservationGuestId)}),
											slots: self.slots.map({BookableConflictsRequestBody.Slot(code: $0.id, startDateTime: $0.startDateTime.toISO8601(), endDateTime: $0.endDateTime.toISO8601())}),
											activityCode: self.activityCode,
											voyageNumber: self.voyageNumber,
											isActivityPaid: self.isActivityPaid,
											activityGroupCode: self.activityGroupCode,
											shipCode: self.shipCode,
                                            appointmentLinkId: self.appointmentLinkId
        )
	}
}
