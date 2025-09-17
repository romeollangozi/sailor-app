//
//  MyVoyageType.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 28.2.25.
//

enum MyVoyageType: String {
    case standard = "Standard"
    case priority = "Priority"
    case rockStar = "RockStar"
    case megaRockStar = "MegaRockStar"

    var isRockStar: Bool {
        switch self {
        case .rockStar, .megaRockStar:
            return true
        default:
            return false
        }
    }
}
