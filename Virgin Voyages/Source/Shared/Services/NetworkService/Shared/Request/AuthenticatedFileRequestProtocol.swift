//
//  AuthenticatedFileRequestProtocol.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 25.10.24.
//

import Foundation

protocol AuthenticatedFileRequestProtocol {
    var fileURL: String { set get }
    var tokenManager: TokenManagerProtocol { get }
}

extension AuthenticatedFileRequestProtocol {
    var tokenManager: TokenManagerProtocol {
        return TokenManager()
    }
}
