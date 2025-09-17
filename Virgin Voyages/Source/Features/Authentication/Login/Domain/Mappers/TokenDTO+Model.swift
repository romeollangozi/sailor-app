//
//  TokenDTO+Model.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/24/25.
//

extension AccountStatusDTO {
	func toDomain() -> AccountStatus {
		return AccountStatus(rawValue: rawValue) ?? .active
	}
}

extension TokenDTO {
	func toDomain() -> Token {
        return Token(refreshToken: refreshToken.value,
					 tokenType: tokenType,
					 accessToken: accessToken,
					 expiresIn: expiresIn,
					 status: status.toDomain())
	}
}
