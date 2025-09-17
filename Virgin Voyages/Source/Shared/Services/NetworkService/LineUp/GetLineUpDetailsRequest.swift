//
//  GetLineUpDetailsRequest.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 8.5.25.
//

import Foundation

struct GetLineUpDetailsRequest: AuthenticatedHTTPRequestProtocol {
	let eventId: String
	let slotId: String
	let reservationGuestId: String
	let voyageNumber: String
	let reservationNumber: String
	let shipCode: String
	
	var path: String {
		return NetworkServiceEndpoint.lineUp + "/\(eventId)"
	}
	
	var method: HTTPMethod {
		return .GET
	}
	
	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}
	
	var queryItems: [URLQueryItem]? {
		var items: [URLQueryItem] = [
			.init(name: "reservationGuestId", value: self.reservationGuestId),
			.init(name: "voyageNumber", value: self.voyageNumber),
			.init(name: "reservationNumber", value: self.reservationNumber),
			.init(name: "shipCode", value: self.shipCode),
			.init(name: "slotId", value: self.slotId)
		]
		
		return items
	}
}

extension NetworkServiceProtocol {
	func getLineUpDetails(eventId: String, slotId: String, reservationGuestId: String, voyageNumber: String, reservationNumber: String, shipCode: String) async throws -> EventItemResponse? {
		let request = GetLineUpDetailsRequest(eventId : eventId, slotId: slotId, reservationGuestId: reservationGuestId, voyageNumber:voyageNumber, reservationNumber: reservationNumber, shipCode: shipCode)
		
		return try await self.requestV2(request, responseModel: EventItemResponse.self)
	}
}

