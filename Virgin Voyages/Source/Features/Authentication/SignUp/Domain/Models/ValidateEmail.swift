//
//  ValidateEmail.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/5/25.
//

import Foundation

struct ValidateEmail {
    let isEmailExist: Bool
}

extension ValidateEmail {
    
    static func sample() -> ValidateEmail {
        ValidateEmail(isEmailExist: false)
    }
}
