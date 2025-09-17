//
//  GetMyVoyageAddOnsRequest.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.3.25.
//

import Foundation

struct GetMyVoyageAddOnsRequest: AuthenticatedHTTPRequestProtocol {

	let reservationNumber: String, shipCode: String, guestId: String

	var path: String {
		return NetworkServiceEndpoint.myVoyageAddons
	}

	var method: HTTPMethod {
		return .GET
	}

	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}

	var queryItems: [URLQueryItem]? {
		let reservationNumber: URLQueryItem = .init(name: "reservationNumber", value: self.reservationNumber)
		let shipCode: URLQueryItem = .init(name: "shipCode", value: self.shipCode)
		let guestId: URLQueryItem = .init(name: "guestId", value: self.guestId)
		return [reservationNumber, shipCode, guestId]
	}
}

struct MyVoyageAddOnsResponse: Decodable {
	let addOns: [Addon]?
	let emptyStatePictogramUrl: String?
	let emptyStateText: String?
	let title: String?

	struct Addon: Decodable {
		let id: String?
		let imageUrl: String?
		let name: String?
		let description: String?
		let isViewable: Bool?
	}
}

extension NetworkServiceProtocol {
	func getMyVoyageAddOns(reservationNumber: String, shipCode: String, guestId: String, cacheOption: CacheOption = .noCache()) async throws -> MyVoyageAddOnsResponse? {
		let request = GetMyVoyageAddOnsRequest(reservationNumber: reservationNumber, shipCode: shipCode, guestId: guestId)
		return try await self.requestV2(request, responseModel: MyVoyageAddOnsResponse.self, cacheOption: cacheOption)
	}
}
