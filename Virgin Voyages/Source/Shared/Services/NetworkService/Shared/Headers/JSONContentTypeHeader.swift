//
//  JSONContentTypeHeader.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/15/24.
//

import Foundation

class JSONContentTypeHeader: HTTPHeadersProtocol {
    var headers: [String : String?] {
        return HTTPHeaders(["Content-Type": "application/json;charset=utf-8",
                            "Accept": "application/json"]).headers
    }
}
