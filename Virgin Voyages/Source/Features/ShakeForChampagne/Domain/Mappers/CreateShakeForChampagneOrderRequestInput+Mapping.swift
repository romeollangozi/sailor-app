//
//  CreateShakeForChampagneOrderRequestInput+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/21/25.
//

import Foundation

extension CreateShakeForChampagneOrderRequestInput {
    
    func toNetworkDto() -> CreateShakeForChampagneOrderRequestBody {
        
        return .init(reservationGuestId: self.reservationGuestId,
                     quantity: self.quantity)
        
    }
}
