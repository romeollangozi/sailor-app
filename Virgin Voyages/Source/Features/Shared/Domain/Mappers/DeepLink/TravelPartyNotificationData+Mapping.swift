//
//  TravelPartyNotificationData+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/8/25.
//

import Foundation

extension TravelPartyNotificationData {
    
    func toDomain() -> TravelParty {
        .init(activityCode: self.activityCode.value,
              currentDay: self.currentDay.value,
              bookingLinkId: self.bookingLinkId.value,
              isBookingProcess: self.isBookingProcess.value,
              appointmentId: self.appointmentId.value,
              currentDate: self.currentDate ?? [],
              categoryCode: self.categoryCode.value)
    }
}
