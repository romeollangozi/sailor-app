//
//  TokenRepository.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/14/24.
//

import Foundation

protocol TokenRepositoryProtocol {
	func storeToken(_ token: Token)
	func getToken() -> Token?
	func deleteToken()
}

class TokenRepository: TokenRepositoryProtocol {

	func storeToken(_ token: Token) {
		UserDefaults.standard.set(token.refreshToken, forKey: "account-refresh")
		UserDefaults.standard.set(token.tokenType, forKey: "account-type")
		UserDefaults.standard.set(token.accessToken, forKey: "account-token")
		UserDefaults.standard.set(token.expiresIn, forKey: "account-expires")
		UserDefaults.standard.set(token.status.rawValue, forKey: "account-status")
	}

	func deleteToken() {
		UserDefaults.standard.removeObject(forKey: "account-refresh")
		UserDefaults.standard.removeObject(forKey: "account-type")
		UserDefaults.standard.removeObject(forKey: "account-token")
		UserDefaults.standard.removeObject(forKey: "account-expires")
		UserDefaults.standard.removeObject(forKey: "account-status")
	}

	func getToken() -> Token? {
		guard let refreshToken = UserDefaults.standard.string(forKey: "account-refresh") else { return nil }
		guard let tokenType = UserDefaults.standard.string(forKey: "account-type") else { return nil }
		guard let accessToken = UserDefaults.standard.string(forKey: "account-token") else { return nil }
		var accountStatus: AccountStatusDTO = .active
		if let status = UserDefaults.standard.string(forKey: "account-status") {
			accountStatus = AccountStatusDTO(rawValue: status) ?? .active
		}
		let expiresIn = UserDefaults.standard.integer(forKey: "account-expires")

		return Token(refreshToken: refreshToken,
					 tokenType: tokenType,
					 accessToken: accessToken,
					 expiresIn: expiresIn,
					 status: accountStatus.toDomain())
	}
}
