//
//  ClientTokenUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 13.9.24.
//

import Foundation

// MARK: - Typealias
public typealias ClientTokenResponse = (token: String, error: String?)

class ClientTokenUseCase {
    
    // MARK: - Properties
	private var service: NetworkServiceProtocol

    // MARK: - Init
	init(service: NetworkServiceProtocol = NetworkService.create()) {
        self.service = service
    }

    // MARK: - Execute
    func execute() async -> String? {
        return try? await service.clientToken()
    }
}
