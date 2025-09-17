//
//  MealPeriod.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 25.11.24.
//

enum MealPeriod: String {
    case brunch = "BRUNCH"
    case dinner = "DINNER"
    
    // Fallback for unsupported values
    init?(rawValue: String) {
        switch rawValue.uppercased() {
        case "BRUNCH": self = .brunch
        case "DINNER": self = .dinner
        default: return nil
        }
    }
}
