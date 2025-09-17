//
//  GetDiscoverLandingRequest.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 6.2.25.
//

import Foundation

struct GetDiscoverLandingRequest: AuthenticatedHTTPRequestProtocol {
    var path: String {
        return NetworkServiceEndpoint.discoverLanding
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
}

struct GetDiscoverLandingItemResponse: Codable {
    let type: String?
    let name: String?
    let imageUrl: String?
    let isLandscape: Bool?
}

extension NetworkServiceProtocol {
	func getDiscoverLanding(cacheOption: CacheOption) async throws -> [GetDiscoverLandingItemResponse] {
        let request = GetDiscoverLandingRequest()
		return try await self.requestV2(request, responseModel: [GetDiscoverLandingItemResponse].self, cacheOption: cacheOption)
    }
}
