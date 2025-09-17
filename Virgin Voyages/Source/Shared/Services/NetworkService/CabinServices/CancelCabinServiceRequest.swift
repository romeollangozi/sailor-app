//
//  CancelCabinServiceRequest.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.4.25.
//

struct CancelCabinServiceRequest: AuthenticatedHTTPRequestProtocol {
	let input: CancelCabinServiceRequestBody
	
	var path: String {
		return NetworkServiceEndpoint.cancelCabinServiceRequest
	}
	
	var method: HTTPMethod {
		return .PUT
	}
	
	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}
		
	var bodyCodable: (any Codable)? {
		return input
	}
}

struct CancelCabinServiceRequestBody: Codable {
	let requestId: String
	let cabinNumber: String
	let status: String
	let activeRequest: String
	let isV1: String
}

extension NetworkServiceProtocol {
    func cancelCabinService(request: CancelCabinServiceRequestBody) async throws -> EmptyResponse? {
		let request = CancelCabinServiceRequest(input: request)
		return try await self.requestV2(request, responseModel: EmptyResponse.self)
	}
}
