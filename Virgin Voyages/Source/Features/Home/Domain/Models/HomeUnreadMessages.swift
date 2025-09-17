//
//  HomeUnreadMessages.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/1/25.
//

import Foundation

struct HomeUnreadMessages {
    let total: Int
}

extension HomeUnreadMessages {
    
    static func sample() -> HomeUnreadMessages {
        HomeUnreadMessages(total: 3)
    }
}
