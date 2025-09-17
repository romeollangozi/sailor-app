//
//  EateryConflictType.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 28.11.24.
//

enum EateryConflictType: String, Codable {
    case hard = "HARD"
    case soft = "SOFT"
    case swapDifferentRestaurantSameDay = "SWAP_DIFFERENT_RESTAURANT_SAME_DAY"
    case swapSameRestaurantByDay = "SWAP_SAME_RESTAURANT_BY_DAY"
    case repeatConflict = "REPEAT"
}
