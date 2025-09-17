//
//  SignUpCredentialsDTO.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 6.9.24.
//

import Foundation

struct SignUpCredentialsDetails: Codable {
    let signUpCredentialsDetails: TokenDTO
    
    enum CodingKeys: String, CodingKey {
        case signUpCredentialsDetails = "authenticationDetails"
    }
}
