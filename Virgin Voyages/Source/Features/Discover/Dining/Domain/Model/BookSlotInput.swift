//
//  BookSlotInput.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 27.11.24.
//

struct BookSlotInput {
    let isPayWithSavedCard: Bool
    let loggedInReservationGuestId: String
    let reservationNumber: String
    let isGift: Bool
    let accessories: [String]
    let currencyCode: String
    let operationType: String?
    let categoryCode: String
    let voyageNumber: String
    let extraGuestCount: Int
    let personDetails: [PersonDetail]
    let activityCode: String
    let shipCode: String
    let activitySlotCode: String
    let startDate: String
    
    struct PersonDetail {
        let personId: String
        let reservationNumber: String
        let guestId: String
    }
}

extension BookSlotInput {
    func toRequestBody() -> BlockSlotRequestRequestBody {
        return BlockSlotRequestRequestBody(
            isPayWithSavedCard: self.isPayWithSavedCard,
            loggedInReservationGuestId: self.loggedInReservationGuestId,
            reservationNumber: self.reservationNumber,
            isGift: self.isGift,
            accessories: self.accessories,
            currencyCode: self.currencyCode,
            operationType: self.operationType,
            categoryCode: self.categoryCode,
            voyageNumber: self.voyageNumber,
            extraGuestCount: self.extraGuestCount,
            personDetails: self.personDetails.map { person in
                BlockSlotRequestRequestBody.PersonDetail(
                    personId: person.personId,
                    reservationNumber: person.reservationNumber,
                    guestId: person.guestId
                )
            },
            activityCode: self.activityCode,
            shipCode: self.shipCode,
            activitySlotCode: self.activitySlotCode,
            startDate: self.startDate
        )
    }
}
