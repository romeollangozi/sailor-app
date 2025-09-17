//
//  VoyageNotificationData+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/13/25.
//

import Foundation

extension VoyageNotificationData {
    
    func toDomain() -> Voyage {
        .init(activityCode: self.activityCode.value,
              currentDay: self.currentDay.value,
              portDepartureTime: self.portDepartureTime.value,
              bookingLinkId: self.bookingLinkId.value,
              isBookingProcess: self.isBookingProcess.value,
              appointmentId: self.appointmentId.value,
              externalBookingId: self.externalBookingId.value,
              currentDate: self.currentDate ?? [],
              categoryCode: self.categoryCode.value,
              portCode: self.portCode.value,
              portArrivalTime: self.portArrivalTime.value)
    }
    
}
