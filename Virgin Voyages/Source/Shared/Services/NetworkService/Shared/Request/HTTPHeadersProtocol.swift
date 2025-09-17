//
//  HTTPHeadersProtocol.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/15/24.
//

import Foundation

protocol HTTPHeadersProtocol {
    var headers: [String: String?] { get }
}

extension HTTPHeadersProtocol {
    func merged(with newHeaders: HTTPHeadersProtocol) -> HTTPHeadersProtocol {
        let mergedHeaders = HTTPHeaders()

        mergedHeaders.headers = self.headers

        for (key, value) in newHeaders.headers {
            mergedHeaders.headers[key] = value
        }

        return mergedHeaders
    }
}
