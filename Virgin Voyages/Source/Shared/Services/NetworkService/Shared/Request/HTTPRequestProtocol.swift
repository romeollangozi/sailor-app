//
//  HTTPRequestProtocol.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/15/24.
//

import Foundation

protocol HTTPRequestProtocol {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeadersProtocol? { get }
    var bodyCodable: Codable? { get }
    var body: [String: Any]? { get }
    var bodyData: Data? { get }
    var timeoutInterval: TimeInterval { get }
}

extension HTTPRequestProtocol {
    
    var headers: HTTPHeadersProtocol? {
        return nil
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var body: [String: Any]? {
        return nil
    }
    
    var bodyCodable: Codable? {
        return nil
    }
    
    var bodyData: Data? {
        if let codable = bodyCodable {
            return try? JSONEncoder().encode(codable)
        }

        if let jsonObject = body, JSONSerialization.isValidJSONObject(jsonObject) {
            return try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
        }

        return nil
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var timeoutInterval: TimeInterval {
		return 30.0
    }
}
