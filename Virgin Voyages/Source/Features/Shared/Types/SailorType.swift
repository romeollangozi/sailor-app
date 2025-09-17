//
//  SailorType.swift
//  Virgin Voyages
//
//  Created by TX on 14.2.25.
//

import Foundation

enum SailorType : String, Codable, Equatable {
    case standard
    case priority
    case rockStar
    case megaRockStar
    
    var isVIP: Bool {
        switch self {
        case .rockStar, .megaRockStar:
            return true
        default:
            return false
        }
    }

    var stringValue: String {
        switch self {
        case .standard: return "Standard"
        case .priority: return "Priority"
        case .rockStar: return "RockStar"
        case .megaRockStar: return "MegaRockStar"
        }
    }
    
    init?(from string: String) {
        switch string {
        case "Standard": self = .standard
        case "Priority": self = .priority
        case "RockStar": self = .rockStar
        case "MegaRockStar": self = .megaRockStar
        default: return nil
        }
    }
}
