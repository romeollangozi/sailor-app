//
//  GetStringResourcesRequest.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 3.5.25.
//

import Foundation

struct GetStringResourcesRequest: AuthenticatedHTTPRequestProtocol {
	var path: String {
		return NetworkServiceEndpoint.stringResources
	}
	
	var method: HTTPMethod {
		return .GET
	}
	
	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}
}

struct GetStringResourcesResponse: Decodable {
	let translations: [String: String]
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.translations = try container.decode([String: String].self)
	}
}

extension NetworkServiceProtocol {
	func getStringResources(cacheOption: CacheOption = .noCache()) async throws -> GetStringResourcesResponse? {
		let request = GetStringResourcesRequest()
		return try await self.requestV2(request, responseModel: GetStringResourcesResponse.self, cacheOption: cacheOption)
	}
}
