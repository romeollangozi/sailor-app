//
//  SocialUser+SignUpInputModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 19.9.24.
//

import Foundation

extension SocialUser {
    func toSignUpInputModel() -> SignUpInputModel {
        return SignUpInputModel(email: email.value, firstName: firstName.value, lastName: lastName.value, dateOfBirth: dateOfBirthComponents)
    }
}
