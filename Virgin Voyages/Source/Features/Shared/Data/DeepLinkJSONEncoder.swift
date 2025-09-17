//
//  DeepLinkJSONEncoder.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 8/7/25.
//

import Foundation

final class DeepLinkJSONEncoder: DeepLinkJSONEncoderProtocol {
    
    func encodeExternalURLLink(url: String) -> (type: String, jsonString: String) {
        guard let urlComponents = URLComponents(string: url),
              let queryItems = urlComponents.queryItems,
              !queryItems.isEmpty else {
            return ("", "{}")
        }
        
        // Get the first query parameter value as type
        let firstParamValue = queryItems.first?.value ?? ""
        
        // Create ordered dictionary manually to preserve URL parameter order
        let remainingItems = Array(queryItems.dropFirst())
        var jsonPairs: [String] = []
        
        for item in remainingItems {
            if let value = item.value {
                // Escape the value for JSON
                if let escapedData = try? JSONEncoder().encode(value),
                   let escapedValue = String(data: escapedData, encoding: .utf8) {
                    jsonPairs.append("\"\(item.name)\":\(escapedValue)")
                }
            }
        }
        
        let jsonString = "{\(jsonPairs.joined(separator: ","))}"
        
        return (firstParamValue, jsonString)
    }
    
}

