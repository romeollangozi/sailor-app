//
//  CreateShakeForChampagneOrderResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/21/25.
//

import Foundation

extension CreateShakeForChampagneOrderResponse {
    
    func toDomain() -> CreateShakeForChampagneOrderRequestResult {
        return .init(orderId: self.orderId.value)
    }
}
