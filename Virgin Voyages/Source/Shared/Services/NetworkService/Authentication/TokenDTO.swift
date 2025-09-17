//
//  TokenDTO.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/24/25.
//


struct TokenDTO: Codable {
	var userType: String
	var refreshToken: String?
	var tokenType: String
	var accessToken: String
	var expiresIn: Int
	var status: AccountStatusDTO
}
