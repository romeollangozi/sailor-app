//
//  GetShipTimeRequest.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/1/25.
//

import Foundation

struct GetShipTimeHeaders: HTTPHeadersProtocol {
	let startTime: String

	var headers: [String : String?] {
		var headers = JSONContentTypeHeader().headers
		headers["startTime"] = startTime
		return headers
	}
}

struct GetShipTimeRequest: AuthenticatedHTTPRequestProtocol {
	let shipcode: String
	let startTime: String

	var path: String {
		return NetworkServiceEndpoint.shipTime
	}

	var method: HTTPMethod {
		return .GET
	}

	var headers: (any HTTPHeadersProtocol)? {
		return GetShipTimeHeaders(startTime: startTime)
	}

	var queryItems: [URLQueryItem]? {
		return [
			URLQueryItem(name: "shipcode", value: self.shipcode)
		]
	}

	var timeoutInterval: TimeInterval {
		return 3.0
	}
}

struct GetShipTimeResponse: Decodable {
	let fromUtcDate: String
	let fromDateOffset: Int
}

extension NetworkServiceProtocol {
	func getShipTime(shipCode: String, startTime: String) async throws -> GetShipTimeResponse {
		let request = GetShipTimeRequest(shipcode: shipCode, startTime: startTime)
		return try await self.requestV2(request, responseModel: GetShipTimeResponse.self)
	}
}
