//
//  ReceiptViewModelMock.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.11.24.
//

import Foundation

extension ShoreThingReceiptDetailsModel {
    static func empty() -> ShoreThingReceiptDetailsModel {
        return ShoreThingReceiptDetailsModel(
			activitiesGuests: [],
			title: "",
            types: "",
			startTime: "",
			startDateTime: Date(),
            location: "",
            energyLevelImageUrl: "",
            duration: "",
            portName: "",
            guests: [],
            reminders: [],
			imageURL: "",
			activityPictogram: "",
			appointmentDetails: [],
            isWithinCancellationWindow: false,
            isPreVoyageEditingStopped: false,
            editButtonText: "",
            viewAllShoreThingsButtonText: "",
            dontForgetText: "",
            purchaseForText: "",
            energyLevelText: "",
            durationText: "",
            portOfCallText: "",
            typeText: "",
            cancelBookingCannotCancelCloseToStartTime: "",
            cancelBookingOkGotIt: "",
            cancelBookingCancelForYourselfOrGroup: "",
            cancelBookingJustForMe: "",
            cancelBookingForTheWholeGroup: "",
            cancelBookinPleaseConfirmProceed: "",
            cancelBookinDoubleCheckNoSlip: "",
            cancelBookinChangedMyMind: "",
            cancelBookinConfirmCancellation: "",
            yesCancel: "",
            bookingCancelled: "",
            cancellation: "",
            doneText: ""
        )
    }
    
    static func mock() -> ShoreThingReceiptDetailsModel {
        let guest1 = Guest(
            guestId: "8ec4d4cb-5156-48c3-a6ac-abe927e02d5a",
            reservationGuestId: "5e02601e-357c-47a8-935f-d4ff9b1cae3b",
            reservationNumber: "554964",
            imageUrl: ""
        )
        let guest2 = Guest(
            guestId: "8ec4d4cb-5156-48c3-a6ac-abe927e02d5a",
            reservationGuestId: "5e02601e-357c-47a8-935f-d4ff9b1cae3b",
            reservationNumber: "554964",
            imageUrl: ""
        )
        
        let reminder1 = Reminder(name: "name1", iconUrl: "")
        let reminder2 = Reminder(name: "name2", iconUrl: "")
        
        return ShoreThingReceiptDetailsModel(
			activitiesGuests: [],
			title: "Ajaccio from the Sky: Helicopter Tour",
            types: "Shore Excursion",
			startTime: "Tue October 15, 10:30am",
			startDateTime: Date(),
            location: "Ajaccio, Corsica",
            energyLevelImageUrl: "https://i.ibb.co/tcHNqXw/Frame.png",
            duration: "3h 10m",
            portName: "Port Vale, Corsica",
            guests: [guest1, guest2],
            reminders: [reminder1, reminder2],
			imageURL: "https://i.ytimg.com/vi/ntvpgujtV1M/maxresdefault.jpg",
			activityPictogram: "",
			appointmentDetails: [],
            isWithinCancellationWindow: false,
            isPreVoyageEditingStopped: false,
            editButtonText: "Edit",
            viewAllShoreThingsButtonText: "View All Shore Things",
            dontForgetText: "Don't forget",
            purchaseForText: "Booked for",
            energyLevelText: "Energy Level",
            durationText: "Duration",
            portOfCallText: "Port of Call",
            typeText: "Type",
            cancelBookingCannotCancelCloseToStartTime: "Hi Sailor, sorry but you can’t cancel this booking so close to the start-time. However, under exceptional circumstances Sailor services may be able to help you.",
            cancelBookingOkGotIt: "Ok, got it",
            cancelBookingCancelForYourselfOrGroup: "Hi Sailor, sorry you can’t make it. Do you want to cancel this booking just for yourself or for the entire group?",
            cancelBookingJustForMe: "Just for me",
            cancelBookingForTheWholeGroup: "For the whole group",
            cancelBookinPleaseConfirmProceed: "Please confirm if you would like to proceed.",
            cancelBookinDoubleCheckNoSlip: "Just double checking we would hate you to lose your place through a slip of the thumb!",
            cancelBookinChangedMyMind: "No, I’ve changed my mind",
            cancelBookinConfirmCancellation: "Confirm Cancellation",
            yesCancel: "Yes, cancel",
            bookingCancelled: "Booking cancelled",
            cancellation: "Cancellation",
            doneText: "Done"
        )
    }
}
