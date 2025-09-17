//
//  SetPinRequest.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 21.7.25.
//


struct SetPinRequest: AuthenticatedHTTPRequestProtocol {
	let input: SetPinRequestBody

	var path: String {
		return NetworkServiceEndpoint.setPin
	}

	var method: HTTPMethod {
		return .POST
	}

	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}

	var bodyCodable: (any Codable)? {
		return input
	}
}

struct SetPinRequestBody: Codable {
	let reservationGuestId: String
	let pin: String

}

extension NetworkServiceProtocol {
	func setPin(request: SetPinRequestBody) async throws -> EmptyModel? {
		let request = SetPinRequest(input: request)
		return try await self.requestV2(request, responseModel: EmptyModel.self)
	}
}
