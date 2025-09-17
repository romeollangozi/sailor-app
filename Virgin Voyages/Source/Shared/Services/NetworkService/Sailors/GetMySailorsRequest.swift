//
//  GetMySailorsRequest.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 19.2.25.
//

import Foundation

struct GetMySailorsRequest: AuthenticatedHTTPRequestProtocol {
	let reservationGuestId: String
	let reservationNumber: String
	let appointmentLinkId: String?
	
	var path: String {
		return NetworkServiceEndpoint.mySailors
	}
	
	var method: HTTPMethod {
		return .GET
	}
	
	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}
	
	var queryItems: [URLQueryItem]? {
		let reservationGuestId: URLQueryItem = .init(name: "reservationGuestId", value: self.reservationGuestId)
		let reservationNumber: URLQueryItem = .init(name: "reservationNumber", value: self.reservationNumber)
		var params = [reservationGuestId, reservationNumber]
		
		if let appointmentLinkId = appointmentLinkId {
			let appointmentLinkIdParam: URLQueryItem = .init(name: "appointmentLinkId", value: appointmentLinkId)
			params.append(appointmentLinkIdParam)
		}
		
		return params
	}
}

struct GetMySailorsRequestResponse: Decodable {
	let guestId: String?
	let reservationGuestId: String?
	let reservationNumber: String?
	let name: String?
	let profileImageUrl: String?
	let isCabinMate: Bool?
}

extension NetworkServiceProtocol {
	func getMySailors(reservationGuestId: String, reservationNumber: String, appointmentLinkId: String?, cacheOption: CacheOption) async throws -> [GetMySailorsRequestResponse] {
		let request = GetMySailorsRequest(reservationGuestId:reservationGuestId, reservationNumber:reservationNumber, appointmentLinkId: appointmentLinkId)
		
		return try await self.requestV2(request, responseModel: [GetMySailorsRequestResponse].self, cacheOption: cacheOption)
	}
}

