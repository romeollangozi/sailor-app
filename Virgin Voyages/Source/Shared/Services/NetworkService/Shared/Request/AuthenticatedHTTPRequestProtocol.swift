//
//  AuthenticatedHTTPRequestProtocol.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/15/24.
//

import Foundation

protocol AuthenticatedHTTPRequestProtocol: HTTPRequestProtocol {
    var tokenManager: TokenManagerProtocol { get }
}

extension AuthenticatedHTTPRequestProtocol {
    var tokenManager: TokenManagerProtocol {
        return TokenManager()
    }
}
