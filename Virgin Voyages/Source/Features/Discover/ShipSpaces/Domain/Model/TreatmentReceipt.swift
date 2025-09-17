//
//  TreatmentReceipt.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 5.2.25.
//

import Foundation

struct TreatmentReceipt {
    let id: String
    let linkId: String
    let treatmentId: String
    let treatmentOptionId: String
    let duration: String
    let imageUrl: String
    let category: String
    let pictogramUrl: String
    let price: Double
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
}


extension TreatmentReceipt {
    
    static func from(response: GetTreatmentAppointmentResponse, reservationGuestId: String) -> TreatmentReceipt? {

        return TreatmentReceipt(
            id: response.id.value,
            linkId: response.linkId.value,
            treatmentId: response.treatmentId.value,
            treatmentOptionId: response.treatmentOptionId.value,
            duration: response.duration.value, imageUrl: response.imageUrl.value,
            category: response.category.value,
            pictogramUrl: response.pictogramUrl.value,
            price: response.price.value,
            name: response.name.value,
			startDateTime: Date.fromISOString(string: response.startDateTime),
            location: response.location.value,
            introduction: response.introduction.value,
            shortDescription: response.shortDescription.value,
            longDescription: response.longDescription.value,
            categoryCode: response.categoryCode.value,
            currencyCode: response.currencyCode.value,
            inventoryState: InventoryState(rawValue: response.inventoryState.value) ?? .nonInventoried,
            bookingType: BookingType(rawValue: response.bookingType.value) ?? .singleDayMultiInstance,
            isPreVoyageBookingStopped: response.isPreVoyageBookingStopped ?? false,
            isWithinCancellationWindow: response.isWithinCancellationWindow ?? false,
            selectedSlot: response.selectedSlot?.toDomain() ?? .empty(),
            slots: response.slots?.map({$0.toDomain()}) ?? [],
            sailors: response.sailors?.map({$0.toDomain()}) ?? [],
            isEditable: response.isEditable.value
        )
    }
    
    
    static func empty() -> TreatmentReceipt {
        return TreatmentReceipt(
            id: "",
            linkId: "",
            treatmentId: "",
            treatmentOptionId: "",
            duration: "",
            imageUrl: "",
            category: "",
            pictogramUrl: "",
            price: 0.0,
            
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
            isEditable: false
        )
    }
    
    static func sample() -> TreatmentReceipt {
        return TreatmentReceipt(
            id: UUID().uuidString,
            linkId: UUID().uuidString,
            treatmentId: UUID().uuidString,
            treatmentOptionId: UUID().uuidString, duration: "40 min.",
            imageUrl: "https://www.prairieeyecenter.com/wp-content/themes/prairie_eye/images/spa-center.jpg",
            category: "Massage",
            pictogramUrl: "https://www.svgrepo.com/show/479379/anchor.svg",
            price: 0.0,
            name: "Relaxing Spa Treatment",
            startDateTime: Date(),
            location: "Deck 5 - Spa Room",
            introduction: "A luxurious spa treatment designed to relax your body and mind.",
            shortDescription: "A 60-minute full-body massage.",
            longDescription: "Enjoy a premium 60-minute massage experience tailored to your needs, with soothing essential oils and expert massage techniques.",
            categoryCode: "SPA",
            currencyCode: "USD",
            inventoryState: .nonPaidInventoried,
            bookingType: .multiDayMultiInstance,
            isPreVoyageBookingStopped: false,
            isWithinCancellationWindow: true,
			selectedSlot: Slot(id: "2", startDateTime: Date(), endDateTime: Date(), status: .available, isBooked: false, inventoryCount: 10),
            slots: [],
            sailors: [SailorSimple(
                guestId: "8d062648-7996-4f90-911c-43e3a5249f63",
                reservationGuestId: "9d73c3d3-1ff6-4148-bc2d-edc257b6b590",
                reservationNumber: "123456",
                name: "You",
                profileImageUrl: "https://cert.gcpshore.virginvoyages.com/dxpcore/mediaitems/bbe9a663-587b-49a4-bf25-3a196ad63ff1"
            ),
			 SailorSimple(
                guestId: "2a07b023-4ed1-462e-bbcd-794fc57c361a",
                reservationGuestId: "539c8738-b7b5-4398-b2f9-d2c5baa1635c",
                reservationNumber: "123457",
                name: "Preferred Name",
                profileImageUrl: nil
            )],
            isEditable: false
        )
    }
}
