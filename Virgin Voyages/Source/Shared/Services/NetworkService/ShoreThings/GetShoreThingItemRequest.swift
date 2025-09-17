//
//  GetShoreThingItemRequest.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.5.25.
//

import Foundation

struct GetShoreThingItemRequest: AuthenticatedHTTPRequestProtocol {
	let id: String,
		slotId: String,
		startDate: String,
		endDate: String,
		portCode: String,
		reservationGuestId: String,
		voyageNumber: String,
		reservationNumber: String

	var path: String {
		return NetworkServiceEndpoint.shorexList + "/" + id
	}
	
	var method: HTTPMethod {
		return .GET
	}
	
	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}
	
	var queryItems: [URLQueryItem]? {
		let slotId: URLQueryItem = .init(name: "slotId", value: self.slotId)
		let startDate: URLQueryItem = .init(name: "startDate", value: self.startDate)
		let endDate: URLQueryItem = .init(name: "endDate", value: self.endDate)
		let portCode: URLQueryItem = .init(name: "portCode", value: self.portCode)
		let reservationGuestId: URLQueryItem = .init(name: "reservationGuestId", value: self.reservationGuestId)
		let voyageNumber: URLQueryItem = .init(name: "voyageNumber", value: self.voyageNumber)
		let reservationNumber: URLQueryItem = .init(name: "reservationNumber", value: self.reservationNumber)
		
		return [slotId, startDate, endDate, portCode, reservationGuestId, voyageNumber, reservationNumber]
	}
}


extension NetworkServiceProtocol {
	func getShoreThingItem(id: String, slotId: String, startDate: String, endDate: String, portCode: String, reservationGuestId: String, voyageNumber: String, reservationNumber: String) async throws -> ShoreThingItemResponse? {
		let request = GetShoreThingItemRequest(id: id, slotId: slotId, startDate: startDate, endDate: endDate, portCode: portCode, reservationGuestId: reservationGuestId, voyageNumber: voyageNumber, reservationNumber: reservationNumber)
		return try await self.requestV2(request, responseModel: ShoreThingItemResponse.self)
	}
}
