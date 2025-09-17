//
//  EateriesConflictsInput.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 27.11.24.
//

struct EateryConflictsInput  {
    struct PersonDetail {
        let personId: String
    }
    
    let personDetails: [PersonDetail]
    let activityCode: String
    let shipCode: String
    let activitySlotCode: String
    let startDateTime: String
    let endDateTime: String
    let activityGroupCode: String
    let isActivityPaid: Bool
    let bookingType: String
    let bookingLinkIds: [String]
    let embarkDate: String
    let debarkDate: String
}


extension EateryConflictsInput {
    func toRequestBody() -> GetEateryConflictsRequestBody {
        return GetEateryConflictsRequestBody(
            personDetails: self.personDetails.map { GetEateryConflictsRequestBody.PersonDetail(personId: $0.personId) },
            activityCode: self.activityCode,
            shipCode: self.shipCode,
            activitySlotCode: self.activitySlotCode,
            startDateTime: self.startDateTime,
            endDateTime: self.endDateTime,
            activityGroupCode: self.activityGroupCode,
            isActivityPaid: self.isActivityPaid,
            bookingType: self.bookingType,
            bookingLinkIds: self.bookingLinkIds,
            embarkDate: self.embarkDate,
            debarkDate: self.debarkDate
        )
    }
}
