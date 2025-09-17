//
//  ReminderNotificationData+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/8/25.
//

import Foundation

extension ReminderNotificationData {
    
    func toDomain() -> Reminder {
        .init(eventSenderUserType: self.eventSenderUserType.value,
              eventSenderUserId: self.eventSenderUserId.value,
              appointmentId: self.appointmentId.value,
              activityCode: self.activityCode.value,
              currentDate: self.currentDate ?? [])
    }
}
