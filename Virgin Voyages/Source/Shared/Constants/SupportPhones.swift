//
//  SupportPhones.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 16.10.24.
//

import Foundation

struct SupportPhones {
    static var sailorServicesPhoneNumber: String {
        let usSupportNumber: String = "954-488-2955"
        let europeSupportNumber: String = "+44-203-003-4919"
        let australiaSupportNumber: String = "+61-1800-491-708"

        let regionCode = Locale.current.regionCode ?? "US" // Default to US if region is not available

        var phoneNumber: String?

        switch regionCode {
        case "US":
            phoneNumber = usSupportNumber
        case "GB", "DE", "FR", "IT", "ES":
            phoneNumber = europeSupportNumber
        case "AU":
            phoneNumber = australiaSupportNumber
        default:
            phoneNumber = usSupportNumber
        }

        return phoneNumber ?? usSupportNumber
    }
}
