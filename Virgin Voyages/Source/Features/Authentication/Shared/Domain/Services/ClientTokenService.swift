//
//  ClientTokenService.swift
//  Virgin Voyages
//
//  Created by TX on 8.8.25.
//

import Foundation

extension NetworkServiceProtocol {
    // MARK: - Get client token
    func clientToken() async throws -> String {
        do {
            let result = try await requestV2(RequestClientTokenEndPoint.clientToken, responseModel: ClientTokenDTO.self)
            return result.accessToken

        } catch {
            throw NetworkServiceError.genericError
        }
    }
}
