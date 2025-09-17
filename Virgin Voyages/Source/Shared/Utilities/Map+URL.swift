//
//  Map+URL.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/25/25.
//

import Foundation

struct MapUrls {
    
    static let appleMapsBaseURL = "http://maps.apple.com/?ll="
    
    static func appleMapsURL(latitude: String, longitude: String) -> String {
        return "\(appleMapsBaseURL)\(latitude),\(longitude)"
    }
        
    static let googleMapsBaseURL = "https://www.google.com/maps/search/?api=1&query="
  
    static func googleMapsURL(latitude: String, longitude: String, placeId: String) -> String {
        return "\(googleMapsBaseURL)\(latitude),\(longitude)&query_place_id=\(placeId)"
    }
}
