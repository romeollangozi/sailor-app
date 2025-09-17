//
//  BookableConflictsInputModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 11.3.25.
//

import Foundation


struct BookableConflictsInputModel {
	let sailors: [Sailor]
	let slots: [slot]
	let activityCode: String
	let isActivityPaid: Bool
	let activityGroupCode: String
    let appointmentLinkId: String
    
	struct Sailor: Codable {
		let reservationNumber: String
		let reservationGuestId: String
	}
	
	struct slot {
		let id: String
		let startDateTime: Date
		let endDateTime: Date
	}
}
