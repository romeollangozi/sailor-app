//
//  BookableConflictsInput.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 19.3.25.
//

import Foundation



struct BookableConflictsInput {
	let sailors: [Sailor]
	let slots: [Slot]
	let activityCode: String
	let voyageNumber: String
	let isActivityPaid: Bool
	let activityGroupCode: String
	let shipCode: String
    let appointmentLinkId: String
	
	struct Sailor {
		let reservationNumber: String
		let reservationGuestId: String
	}
	
	struct Slot {
		let id: String
		let startDateTime: Date
		let endDateTime: Date
	}
}

extension BookableConflictsInputModel {
	static func empty() -> Self {
        return .init(sailors: [], slots: [], activityCode: "", isActivityPaid: false, activityGroupCode: "", appointmentLinkId: "")
	}
}
