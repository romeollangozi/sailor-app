//
//  AnalyticsEvent.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 18.12.24.
//


import Foundation

enum AnalyticsEvent {
    
    // User Actions
    case userSignedIn(userID: String)
    case userSignedOut
    case userRegistered(userID: String, method: String)
    
    // Screen Views
    case screenViewed(screenName: String)
    
    // Button Taps
    case buttonTapped(buttonName: String)
    
    // Purchases
    case purchaseMade(productID: String, price: Double, currency: String)
    
    // Custom Event
    case customEvent(name: String, attributes: [String: Any]?)
    

    var details: (name: String, attributes: [String: Any]?) {
        switch self {
        case .userSignedIn(let userID):
            return ("UserSignedIn", ["user_id": userID])
        case .userSignedOut:
            return ("UserSignedOut", nil)
        case .userRegistered(let userID, let method):
            return ("UserRegistered", ["user_id": userID, "method": method])
        case .screenViewed(let screenName):
            return ("ScreenViewed", ["screen_name": screenName])
        case .buttonTapped(let buttonName):
            return ("ButtonTapped", ["button_name": buttonName])
        case .purchaseMade(let productID, let price, let currency):
            return ("PurchaseMade", ["product_id": productID, "price": price, "currency": currency])
        case .customEvent(let name, let attributes):
            return (name, attributes)
        }
    }
}
