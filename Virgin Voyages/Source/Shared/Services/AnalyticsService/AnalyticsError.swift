//
//  AnalyticsError.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 18.12.24.
//

import Foundation

enum AnalyticsError {
    case networkError(message: String, timeout: Int)
    case apiError(message: String, endpoint: String)
    case customError(name: String, message: String, attributes: [String: Any]?)
    
    // Helper to generate error name, message, and attributes
    var details: (name: String, message: String, attributes: [String: Any]?) {
        switch self {
        case .networkError(let message, let timeout):
            return ("NetworkError", message, ["timeout": timeout])
        case .apiError(let message, let endpoint):
            return ("APIError", message, ["endpoint": endpoint])
        case .customError(let name, let message, let attributes):
            return (name, message, attributes)
        }
    }
}
