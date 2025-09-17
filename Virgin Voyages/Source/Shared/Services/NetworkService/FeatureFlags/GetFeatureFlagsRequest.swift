//
//  GetFeatureFlagsRequest.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.8.25.
//

import Foundation

struct GetFeatureFlagsRequest: AuthenticatedHTTPRequestProtocol {
	
	var path: String {
		return "\(NetworkServiceEndpoint.featureFlags)"
	}
	var method: HTTPMethod {
		return .GET
	}
	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}
	
	var queryItems: [URLQueryItem]? {
		return []
	}
}

struct FeatureFlagResponse: Codable {
	let feature: String?
	let description: String?
	let platforms: Platforms?
	let restrictions: Restrictions?

	struct Platforms: Codable {
		let android: PlatformDetails?
		let ios: PlatformDetails?

		struct PlatformDetails: Codable {
			let enabled: Bool?
		}
	}

	struct Restrictions: Codable {
		let ships: [String]?
		let userIds: [String]?
	}
}

struct GetFeatureFlagsResponse: Codable {
	let featureFlags: [FeatureFlagResponse]
}

extension NetworkServiceProtocol {
	func getFeatureFlags(cacheOption: CacheOption) async throws -> GetFeatureFlagsResponse? {
		let request = GetFeatureFlagsRequest()
		
		
		return try await self.requestV2(request, responseModel: GetFeatureFlagsResponse.self, cacheOption: cacheOption)
	}
}
