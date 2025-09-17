//
//  ClientTokenDTO.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 13.9.24.
//

import Foundation

// MARK: - ClientTokenDTO
struct ClientTokenDTO: Codable {
    let accessToken, clientTokenTokenType: String
    let expiresIn: Int
    let scope, companyid, tokenType, jti: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case clientTokenTokenType = "token_type"
        case expiresIn = "expires_in"
        case scope, companyid, tokenType, jti
    }
}
