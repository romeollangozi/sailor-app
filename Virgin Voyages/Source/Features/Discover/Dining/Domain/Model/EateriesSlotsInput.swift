//
//  EateriesSlotsInput.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 25.11.24.
//

struct EateriesSlotsInput {
    let voyageNumber: String
    let voyageId: String
    let searchSlotDate: String
    let embarkDate: String
    let debarkDate: String
    let mealPeriod: MealPeriod
    let shipCode: String
    let guestCount: Int
    let venues: [Venue]
    let reservationNumber: String
    let reservationGuestId: String

    struct Venue {
        let externalId: String
        let venueId: String
    }
}

extension EateriesSlotsInput {
    func toRequestBody() -> GetEateriesSlotsRequestBody {
        return GetEateriesSlotsRequestBody(
            voyageNumber: voyageNumber,
            voyageId: voyageId,
            searchSlotDate: searchSlotDate,
            embarkDate: embarkDate,
            debarkDate: debarkDate,
            mealPeriod: mealPeriod.rawValue,
            shipCode: shipCode,
            guestCount: guestCount,
            venues: venues.map { venue in
                GetEateriesSlotsRequestBody.Venue(
                    externalId: venue.externalId,
                    venueId: venue.venueId
                )
            },
            reservationNumber: reservationNumber,
            reservationGuestId: reservationGuestId
        )
    }
}
