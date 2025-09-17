//
//  ShakeForChampagneNotificationData+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/31/25.
//

import Foundation

extension ShakeForChampagneNotificationData {
    
    func toDomain() -> ShakeForChampagneData {
        .init(ORDER_ID: self.ORDER_ID.value,
              ACTIVITY_CODE: self.ACTIVITY_CODE.value)
    }
}
