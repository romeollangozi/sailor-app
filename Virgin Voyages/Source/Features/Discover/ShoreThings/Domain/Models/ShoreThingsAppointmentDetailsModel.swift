//
//  ActivityAppointmentDetailsModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 22.11.24.
//
//

import Foundation

struct ShoreThingReceiptDetailsModel {
	let activitiesGuests: [ActivitiesGuest]
    let title: String
    let types: String
    let startTime: String
	let startDateTime: Date
    let location: String
    let energyLevelImageUrl: String?
    let duration: String
    let portName: String
	
    let guests: [Guest]
    let reminders: [Reminder]
    let imageURL: String
    let activityPictogram: String
	let appointmentDetails: [AppointmentDetail]
    let isWithinCancellationWindow: Bool
    let isPreVoyageEditingStopped: Bool

    //Translations
    let editButtonText: String
    let viewAllShoreThingsButtonText: String
    let dontForgetText: String
    let purchaseForText: String
    let energyLevelText: String
    let durationText: String
    let portOfCallText: String
    let typeText: String
    let cancelBookingCannotCancelCloseToStartTime: String
    let cancelBookingOkGotIt: String
    let cancelBookingCancelForYourselfOrGroup: String
    let cancelBookingJustForMe: String
    let cancelBookingForTheWholeGroup: String
    let cancelBookinPleaseConfirmProceed: String
    let cancelBookinDoubleCheckNoSlip: String
    let cancelBookinChangedMyMind: String
    let cancelBookinConfirmCancellation: String
    let yesCancel: String
    let bookingCancelled: String
    let cancellation: String
    let doneText: String
    
    var cancelationText: String {
        return "\(title), \(startTime)"
    }
    
    struct Guest {
        let guestId: String
        let reservationGuestId: String
        let reservationNumber: String
        let imageUrl: String?
    }
    
    struct Reminder {
        let name: String
        let iconUrl: String
    }

	struct AppointmentDetail {
		struct GuestDetail {
			let guestId: String
			let reservationGuestId: String
			let reservationNumber: String
			let profilePhotoMediaItemUrl: String?
		}

		let appointmentId: String
		let bookedAmount: Int
		let refundAmount: Int
		let guestDetails: [GuestDetail]
		let appointmentLinkId: String
		let currencyCode: String
	}
}
