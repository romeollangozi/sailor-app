//
//  GetVipBenefitsRequest.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.3.25.
//

import Foundation

struct GetVipBenefitsRequest: AuthenticatedHTTPRequestProtocol {
	let guestTypeCode: String
	let shipCode: String

	var path: String {
		return NetworkServiceEndpoint.getVipBenefits
	}

	var method: HTTPMethod {
		return .GET
	}

	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}

	var queryItems: [URLQueryItem]? {
		let guestTypeCode: URLQueryItem = .init(name: "guestTypeCode", value: self.guestTypeCode)
		let shipCode: URLQueryItem = .init(name: "shipCode", value: self.shipCode)

		return [guestTypeCode, shipCode]
	}
}

struct VipBenefitsResponse: Decodable {
	struct Benefit: Decodable {
		let sequence: String?
		let iconUrl: String?
		let summary: String?
	}

	let benefits: [Benefit]?
	let supportEmailAddress: String?
}

extension NetworkServiceProtocol {
	func getVipBenefits(guestTypeCode: String, shipCode: String) async throws -> VipBenefitsResponse? {
		let request = GetVipBenefitsRequest(guestTypeCode: guestTypeCode, shipCode: shipCode)
		return try await self.requestV2(request, responseModel: VipBenefitsResponse.self)
	}
}
