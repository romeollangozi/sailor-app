//
//  ErrorMessageParser.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 5.12.24.
//

import Foundation

class ErrorMessageParser {
    static func parse(_ errorMessage: String) -> String {
        // Locate the JSON part of the string
        guard let jsonStartIndex = errorMessage.range(of: "{\"")?.lowerBound else {
            return errorMessage // Return original if no JSON part found
        }
        
        var jsonString = String(errorMessage[jsonStartIndex...])
        
        // Remove the extra surrounding quotes
        if jsonString.hasSuffix("\"") {
            jsonString.removeLast() // Remove trailing quote
        }
        
        // Convert the string into valid JSON data
        guard let data = jsonString.data(using: .utf8) else {
            return errorMessage // Return original if data conversion fails
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let detail = json["detail"] as? [String] {
                // Join the details into a single string
                return detail.joined(separator: ", ")
            }
        } catch {
            // Return original message if parsing fails
            return errorMessage
        }
        
        // Return original message if parsing fails
        return errorMessage
    }
}
