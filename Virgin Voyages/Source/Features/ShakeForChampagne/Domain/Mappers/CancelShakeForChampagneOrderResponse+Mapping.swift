//
//  CancelShakeForChampagneOrderResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/22/25.
//

import Foundation

extension CancelShakeForChampagneOrderResponse {
    
    func toDomain() -> CancelShakeForChampagneOrderRequestResult {
        .init(orderId: self.orderId.value,
              message: self.message.value)
    }
    
}
