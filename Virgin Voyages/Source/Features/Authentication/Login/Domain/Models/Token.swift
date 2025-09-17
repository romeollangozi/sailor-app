//
//  Token.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/14/24.
//

import Foundation

class Token {

	var refreshToken: String
	var tokenType: String
	var accessToken: String
	var expiresIn: Int
	var status: AccountStatus

	init(refreshToken: String,
		 tokenType: String,
		 accessToken: String,
		 expiresIn: Int,
		 status: AccountStatus) {
		self.refreshToken = refreshToken
		self.tokenType = tokenType
		self.accessToken = accessToken
		self.expiresIn = expiresIn
		self.status = status
	}
	
}
