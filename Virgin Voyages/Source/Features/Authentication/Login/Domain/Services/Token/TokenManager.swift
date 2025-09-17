//
//  TokenManager.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/14/24.
//

protocol TokenManagerProtocol {
	var token: Token? { get }
}

class TokenManager: TokenManagerProtocol {

	private var repository: TokenRepositoryProtocol

	init(repository: TokenRepositoryProtocol = TokenRepository()) {
		self.repository = repository
	}

	var token: Token? {
		get {
			return repository.getToken()
		}
	}
}
