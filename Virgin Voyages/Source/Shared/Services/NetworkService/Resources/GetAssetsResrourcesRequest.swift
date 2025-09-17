//
//  GetAssetsResrourcesRequest.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 3.5.25.
//

import Foundation

struct GetAssetsResrourcesRequest: AuthenticatedHTTPRequestProtocol {
	var path: String {
		return NetworkServiceEndpoint.assetResources
	}
	
	var method: HTTPMethod {
		return .GET
	}
	
	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}
}

struct GetAssetsResrourcesResponse: Decodable {
	let assets: [String: AssetDetails]
	
	struct AssetDetails: Decodable {
		let link: String
		let format: String
		let width: String
		let type: String
		let height: String
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.assets = try container.decode([String: AssetDetails].self)
	}
}

extension NetworkServiceProtocol {
	func getAssetResources(cacheOption: CacheOption = .noCache()) async throws -> GetAssetsResrourcesResponse? {
		let request = GetAssetsResrourcesRequest()
		return try await self.requestV2(request, responseModel: GetAssetsResrourcesResponse.self, cacheOption: cacheOption)
	}
}
