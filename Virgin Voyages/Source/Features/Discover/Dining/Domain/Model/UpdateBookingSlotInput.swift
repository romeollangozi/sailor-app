//
//  UpdateBookingSlotInput.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 28.11.24.
//

struct UpdateBookingSlotInput {
    let isPayWithSavedCard: Bool
    let loggedInReservationGuestId: String
    let reservationNumber: String
    let isGift: Bool
    let accessories: [String]
    let currencyCode: String
    let operationType: String
    let categoryCode: String
    let voyageNumber: String
    let extraGuestCount: Int
    let personDetails: [PersonDetail]
    let activityCode: String
    let shipCode: String
    let activitySlotCode: String
    let startDate: String
    let appointmentLinkId: String
    let isSwapped: Bool
    
    struct PersonDetail {
        let personId: String
        let reservationNumber: String
        let guestId: String
        let status: String?
    }
}

extension UpdateBookingSlotInput {
    func toRequestBody() -> UpdateBookingRequestRequestBody {
        return UpdateBookingRequestRequestBody(
            isPayWithSavedCard: isPayWithSavedCard,
            loggedInReservationGuestId: loggedInReservationGuestId,
            reservationNumber: reservationNumber,
            isGift: isGift,
            accessories: accessories,
            currencyCode: currencyCode,
            operationType: operationType,
            categoryCode: categoryCode,
            voyageNumber: voyageNumber,
            extraGuestCount: extraGuestCount,
            personDetails: personDetails.map {
                UpdateBookingRequestRequestBody.PersonDetail(
                    personId: $0.personId,
                    reservationNumber: $0.reservationNumber,
                    guestId: $0.guestId,
                    status: $0.status
                )
            },
            activityCode: activityCode,
            shipCode: shipCode,
            activitySlotCode: activitySlotCode,
            startDate: startDate,
            appointmentLinkId: appointmentLinkId,
            isSwapped: isSwapped
        )
    }
}
