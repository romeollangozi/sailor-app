//
//  EmailSignInRequest.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/24/25.
//

import Foundation

struct EmailSignInRequest: BasicAuthenticatedHTTPRequestProtocol {

	private let body: EmailSignInRequestBody

	var path: String {
		return NetworkServiceEndpoint.signInWithEmail
	}

	var method: HTTPMethod {
		return .POST
	}

	var headers: (any HTTPHeadersProtocol)? {
		return EmailSignInHeaders()
	}

	var bodyCodable: Codable? {
		return body
	}

	init(email: String, password: String) {
		self.body = EmailSignInRequestBody(userName: email, password: password)
	}
}

struct EmailSignInHeaders: HTTPHeadersProtocol {
	var headers: [String : String?] {
		var headers = JSONContentTypeHeader().headers
		headers["isNsaErrors"] = "true"
		return headers
	}
}

struct EmailSignInRequestBody : Codable {
	let userName: String
	let password: String
}

extension NetworkServiceProtocol {
	func signIn(email: String, password: String) async throws -> TokenDTO {
		let request = EmailSignInRequest(email: email, password: password)
		return try await self.requestV2(request, responseModel: TokenDTO.self)
	}
}
