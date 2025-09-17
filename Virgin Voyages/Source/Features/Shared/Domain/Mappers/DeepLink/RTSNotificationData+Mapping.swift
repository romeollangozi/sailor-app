//
//  RTSNotificationData+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/14/25.
//

import Foundation

extension RTSNotificationData {
    
    func toDomain() -> RTS {
        .init(reservationId: self.reservationId.value,
              reservationNumber: self.reservationNumber.value,
              guestId: self.guestId.value)
    }
    
}
