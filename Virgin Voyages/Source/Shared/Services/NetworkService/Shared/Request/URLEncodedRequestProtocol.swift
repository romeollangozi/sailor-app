//
//  URLEncodedRequestProtocol.swift
//  Virgin Voyages
//
//  Created by TX on 19.5.25.
//

import Foundation

protocol URLEncodedRequestProtocol: AuthenticatedHTTPRequestProtocol {
    var parameters: [String: Any] { get }
}

extension Dictionary where Key == String, Value == Any {
    func percentEncoded() -> Data? {
        return map { key, value -> String in
            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let encodedValue: String
            if let array = value as? [Any] {
                // Convert array to JSON string
                if let data = try? JSONSerialization.data(withJSONObject: array, options: []),
                   let jsonString = String(data: data, encoding: .utf8) {
                    encodedValue = jsonString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                } else {
                    encodedValue = ""
                }
            } else {
                encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            }
            return "\(encodedKey)=\(encodedValue)"
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
