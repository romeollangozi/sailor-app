//
//  TreatmentReceipt 2.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 6.2.25.
//

import Foundation

struct TreatmentReceiptModel: Equatable, Hashable {
    let id: String
    let linkId: String
    let treatmentId: String
    let treatmentOptionId: String
    let price: Double
    let imageUrl: String
    let category: String
    let pictogramUrl: String
    let duration: String
    let name: String
    let startDateTime: Date
    let location: String
    
    let introduction: String
    let shortDescription: String
    let longDescription: String
    
    let categoryCode: String
    let currencyCode: String
    
    let inventoryState: InventoryState
    let bookingType: BookingType
    
    let isPreVoyageBookingStopped: Bool
    let isWithinCancellationWindow: Bool
    
    let selectedSlot: Slot?
    let slots: [Slot]
	let sailors: [SailorSimple]
    let isEditable: Bool
    
    let editCancelTitle = "Edit/Cancel"
    let viewAllTitle = "View all Beauty & Body"
    var bookedForText = "Booked for"
    var refundText: String = ""
    var cancelConfirmationSubtitle: String = ""

    static func from(_ receipt: TreatmentReceipt) -> TreatmentReceiptModel {
        return TreatmentReceiptModel(
            id: receipt.id,
            linkId: receipt.linkId,
            treatmentId: receipt.treatmentId,
            treatmentOptionId: receipt.treatmentOptionId,
            price: receipt.price,

            imageUrl: receipt.imageUrl,
            category: receipt.category,
            pictogramUrl: receipt.pictogramUrl,

            duration: receipt.duration, name: receipt.name,
            startDateTime: receipt.startDateTime,
            location: receipt.location,
            
            introduction: receipt.introduction,
            shortDescription: receipt.shortDescription,
            longDescription: receipt.longDescription,
            
            categoryCode: receipt.categoryCode,
            currencyCode: receipt.currencyCode,
            
            inventoryState: receipt.inventoryState,
            bookingType: receipt.bookingType,
            
            isPreVoyageBookingStopped: receipt.isPreVoyageBookingStopped,
            isWithinCancellationWindow: receipt.isWithinCancellationWindow,
            
            selectedSlot: receipt.selectedSlot,
			slots: receipt.slots
				.uniqueSlots()
				.sortedByStartDate(),
			sailors: receipt.sailors,
            isEditable: receipt.isEditable
        )
    }
}

extension TreatmentReceiptModel {
    static func sample() -> TreatmentReceiptModel {
        return TreatmentReceiptModel(
            id: "12345",
            linkId: "67890",
            treatmentId: "TRT-001",
            treatmentOptionId: "OPT-001",
            price: 0.0,

            imageUrl: "https://example.com/image.jpg",
            category: "Spa",
            pictogramUrl: "https://example.com/pictogram.png",
            duration: "40 min",

            name: "Relaxing Spa Treatment",
            startDateTime: Date(),
            location: "Deck 5 - Serenity Spa",

            introduction: "Experience ultimate relaxation.",
            shortDescription: "A 60-minute full-body massage.",
            longDescription: "Indulge in a 60-minute full-body massage performed by expert therapists using essential oils to rejuvenate your body and mind.",

            categoryCode: "SPA",
            currencyCode: "USD",

            inventoryState: .nonPaidInventoried,
            bookingType: .multiDayMultiInstance,

            isPreVoyageBookingStopped: false,
            isWithinCancellationWindow: true,

            selectedSlot: Slot.sample(),
            slots: [Slot.sample()],
			sailors: [SailorSimple(
                guestId: "8d062648-7996-4f90-911c-43e3a5249f63",
                reservationGuestId: "659e9fb8-e897-4f59-aa08-99d8913a3b75",
                reservationNumber: "123456",
                name: "You",
                profileImageUrl: "https://cert.gcpshore.virginvoyages.com/dxpcore/mediaitems/bbe9a663-587b-49a4-bf25-3a196ad63ff1"
            ),
					  SailorSimple(
                guestId: "2a07b023-4ed1-462e-bbcd-794fc57c361a",
                reservationGuestId: "179d3cd1-4fd6-4fe8-9946-caf9de5bb698",
                reservationNumber: "123457",
                name: "Preferred Name",
                profileImageUrl: nil
            )],
            isEditable: false,
            refundText: "",
            cancelConfirmationSubtitle: ""
        )
    }
    
    static func empty() -> TreatmentReceiptModel {
        return TreatmentReceiptModel(
            id: "",
            linkId: "",
            treatmentId: "",
            treatmentOptionId: "",
            price: 0.0,

            imageUrl: "",
            category: "",
            pictogramUrl: "",
            duration: "",

            name: "",
            startDateTime: Date(),
            location: "",

            introduction: "",
            shortDescription: "",
            longDescription: "",

            categoryCode: "",
            currencyCode: "",

            inventoryState: .nonInventoried,
            bookingType: .other,

            isPreVoyageBookingStopped: false,
            isWithinCancellationWindow: false,

            selectedSlot: nil,
            slots: [],
            sailors: [],
            isEditable: false,
            refundText: "",
            cancelConfirmationSubtitle: ""
        )
    }
}

//extension TreatmentReceiptModel: CancelBookableActivity {
//	var appointmentLinkId: String {
//		return linkId
//	}
//	
//	var cancelationCompletedText: String {
//		return cancelConfirmationSubtitle
//	}
//	
//	var refundTextForIndividual: String {
//		return refundText
//	}
//	
//	var refundTextForGroup: String? {
//		return nil
//	}
//
//	var refundConfirmationMessage: String {
//		return ""
//	}
//}
