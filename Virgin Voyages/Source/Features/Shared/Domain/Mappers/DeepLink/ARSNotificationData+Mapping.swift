//
//  ARSNotificationData+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/14/25.
//

import Foundation

extension ARSNotificationData {
    
    func toDomain() -> ARS {
        .init(eventSenderUserType: self.eventSenderUserType.value,
              eventSenderUserId: self.eventSenderUserId.value,
              bookingLinkId: self.bookingLinkId.value,
              appointmentId: self.appointmentId.value,
              currentDate: self.currentDate ?? [])
    }
}
