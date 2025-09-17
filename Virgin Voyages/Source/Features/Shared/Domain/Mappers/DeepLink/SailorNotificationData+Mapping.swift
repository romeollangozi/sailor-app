//
//  SailorNotificationData+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/22/25.
//

import Foundation

extension SailorNotificationData {
    
    func toDomain() -> SailorData {
        .init(externalUrl: self.externalUrl.value)
    }
    
}
