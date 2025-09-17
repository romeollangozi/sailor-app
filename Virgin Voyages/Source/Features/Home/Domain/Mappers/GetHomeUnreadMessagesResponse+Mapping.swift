//
//  GetHomeUnreadMessagesResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/1/25.
//

import Foundation

extension GetHomeUnreadMessagesResponse {
    
    func toDomain() -> HomeUnreadMessages {
        return HomeUnreadMessages(total: self.total ?? 0)
    }
}
