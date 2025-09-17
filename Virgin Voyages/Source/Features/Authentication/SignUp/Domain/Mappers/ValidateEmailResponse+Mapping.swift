//
//  ValidateEmailResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/5/25.
//

import Foundation

extension ValidateEmailResponse {
    
    func toDomain() -> ValidateEmail {
        return ValidateEmail(isEmailExist: self.isEmailExist.value)
    }
    
}
