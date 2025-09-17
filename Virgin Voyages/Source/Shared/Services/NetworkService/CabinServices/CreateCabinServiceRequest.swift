//
//  AddCabinServiceRequest.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 25.4.25.
//

import Foundation

struct CreateCabinServiceRequest: AuthenticatedHTTPRequestProtocol {
	let input: CreateCabinServiceRequestBody
	
	var path: String {
		return NetworkServiceEndpoint.createCabinServiceRequest
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
    
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "device", value: "app"),
            .init(name: "isV1", value: "true")
        ]
    }
}

struct CreateCabinServiceRequestBody: Codable {
	let reservationId: String
	let reservationGuestId: String
	let guestId: String
	let cabinNumber: String
	let requestName: String
}

struct CreateCabinServiceResponse: Decodable {
	let requestId: String?
}

extension NetworkServiceProtocol {
	func createCabinServiceRequest(request: CreateCabinServiceRequestBody) async throws -> CreateCabinServiceResponse {
		let request = CreateCabinServiceRequest(input: request)
		return try await self.requestV2(request, responseModel: CreateCabinServiceResponse.self)
	}
}
