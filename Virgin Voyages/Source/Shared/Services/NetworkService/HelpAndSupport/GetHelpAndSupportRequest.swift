//
//  GetHelpAndSupportRequest.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.4.25.
//

struct GetHelpAndSupportRequest: AuthenticatedHTTPRequestProtocol {
	var path: String {
		return NetworkServiceEndpoint.helpAndSupport
	}

	var method: HTTPMethod {
		return .GET
	}

	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}
}

struct GetHelpAndSupportResponse: Decodable {
	let supportEmailAddress: String?
	let supportPhoneNumber: String?
	let categories: [Category]?
	let deckLocation: String?
	let externalId: String?
	let name: String?
	
	struct Category: Decodable {
		let cta: String?
		let sequenceNumber: String?
		let name: String?
		let externalId: String?
		let nodeType: String?
		let articles: [Article]?
		
		struct Article: Decodable {
			let name: String?
			let nodeType: String?
			let body: String?
		}
	}
}

extension NetworkServiceProtocol {
	func fetchHelpAndSupport(cacheOption: CacheOption) async throws -> GetHelpAndSupportResponse? {
		let request = GetHelpAndSupportRequest()
		return try await self.requestV2(request, responseModel: GetHelpAndSupportResponse.self, cacheOption: cacheOption)
	}
}
