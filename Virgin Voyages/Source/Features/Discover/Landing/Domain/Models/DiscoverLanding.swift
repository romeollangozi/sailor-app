//
//  DiscoverLanding.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 6.2.25.
//

import Foundation

struct DiscoverLandingItem: Equatable {
    let id: String = UUID().uuidString
	let type: DiscoverType
    let name: String
    let imageUrl: String?
    let isLandscape: Bool
}
