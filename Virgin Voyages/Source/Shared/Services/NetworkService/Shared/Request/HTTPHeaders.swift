//
//  HTTPHeaders.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/15/24.
//

import Foundation

class HTTPHeaders: HTTPHeadersProtocol {
    var headers: [String: String?] = [:]

    init(_ headers: [String : String?] = [:]) {
        self.headers = headers
    }
}
