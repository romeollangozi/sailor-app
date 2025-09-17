//
//  BookableConflictsInputModel+Mapping.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 20.3.25.
//


extension BookableConflictsInputModel {
	func toDomain(voyageNumber: String, reservationNumber: String, shipCode: String) -> BookableConflictsInput {
		return BookableConflictsInput(sailors: sailors.map({BookableConflictsInput.Sailor(reservationNumber: $0.reservationNumber, reservationGuestId: $0.reservationGuestId)}),
									  slots: slots.map({BookableConflictsInput.Slot(id: $0.id, startDateTime: $0.startDateTime, endDateTime: $0.endDateTime)}),
									  activityCode: activityCode,
									  voyageNumber: voyageNumber,
									  isActivityPaid: isActivityPaid,
									  activityGroupCode: activityGroupCode,
									  shipCode: shipCode,
                                      appointmentLinkId: appointmentLinkId
        )
	}
}
