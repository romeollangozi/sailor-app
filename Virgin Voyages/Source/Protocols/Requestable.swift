//
//  Requestable.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/5/23.
//

import Foundation

protocol Requestable {
	associatedtype RequestType: Encodable
	associatedtype QueryType: Encodable
	associatedtype ResponseType: Decodable
	var path: String { get }
	var method: Endpoint.Method { get }
	var cachePolicy: Endpoint.CachePolicy { get }
	var authenticationType: Endpoint.AuthenticationType { get }
	var pathComponent: String? { set get }
	var request: RequestType? { set get }
	var query: QueryType? { set get }
	var scope: Endpoint.RequestScope { get }
    var customHeaders: [String: String]? { get }

}

extension Requestable {
    
    var customHeaders: [String: String]? {
        return nil
    }

	func url(host: Endpoint.Host) throws -> URL {
		guard let url = try host.url(path: path, scope: scope, pathComponent: pathComponent, query: query) else {
			throw Endpoint.Error("No URL")
		}
		
		return url
	}
	
	func urlRequest(host: Endpoint.Host, authorization: String) throws -> URLRequest {
		let url = try url(host: host)
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = method.description
		urlRequest.addValue(authorization, forHTTPHeaderField: "Authorization")
		urlRequest.addValue(method.contentType, forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("true", forHTTPHeaderField: "isNsaErrors")
		
        // Add custom headers if provided
        if let customHeaders = customHeaders {
            for (key, value) in customHeaders {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }

		switch method {
		case .form:
			if let data = try? self.request?.formData() {
				urlRequest.httpBody = data
			}
			break
			
		case .get:
			break
			
		default:
			let body = try JSONEncoder().encode(self.request)
			urlRequest.httpBody = body
		}
		
		return urlRequest
	}
	
	func saveName(host: Endpoint.Host) -> String {
		var string = self.path
		let encoder = JSONEncoder()
		encoder.outputFormatting = .sortedKeys
		
		if let requestData = try? encoder.encode(request), let text = String(data: requestData, encoding: .utf8) {
			string += text
		}
		
		if let queryData = try? encoder.encode(query), let text = String(data: queryData, encoding: .utf8) {
			string += text
		}
		
		var hashValue: UInt64 = 5381
		let prime: UInt64 = 31
		for character in string.utf8 {
			hashValue = (hashValue &* prime) &+ UInt64(character)
		}
		
		return String(hashValue)
	}
	
	func sanitize(data: Data) -> Data {		
		if data.count == 0 {
			// Sometimes we get an empty response
			// To make is easier to decode return an empty object instead			
			let empty = String(describing: ResponseType.self) == "Array<Response>" ? "[]" : "{}"
			return empty.data(using: .utf8) ?? data
		}
		
		guard let string = String(data: data, encoding: .utf8) else {
			return data
		}
		
		if string == "{}" {
			return data
		}
		
		// Sometimes we get an empty object instead of null
		return string.replacingOccurrences(of: "{}", with: "null").data(using: .utf8) ?? data
	}
}
