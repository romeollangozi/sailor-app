//
//  FetchCheckInStatusRequest.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/6/25.
//


import Foundation

struct FetchCheckInStatusRequest: AuthenticatedHTTPRequestProtocol {
	let reservationNumber: String
	let reservationGuestID: String

	var path: String {
		return NetworkServiceEndpoint.fetchCheckInStatus
	}

	var method: HTTPMethod {
		return .GET
	}

	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}

	var queryItems: [URLQueryItem]? {
		let reservationNumber: URLQueryItem = .init(name: "reservation-number", value: self.reservationNumber)
		let reservationGuestID: URLQueryItem = .init(name: "reservation-guest-id", value: self.reservationGuestID)

		return [reservationNumber, reservationGuestID]
	}

	var timeoutInterval: TimeInterval = 3.0
}

struct FetchCheckInStatusResponse: Decodable {
	let isGuestCheckedIn: Bool
	let isGuestOnBoard: Bool
	let reservationGuestId: String
}

extension NetworkServiceProtocol {
	func fetchCheckInStatus(reservationNumber: String,
							reservationGuestID: String) async throws -> FetchCheckInStatusResponse {
		let request = FetchCheckInStatusRequest(reservationNumber: reservationNumber,
												reservationGuestID: reservationGuestID)
		return try await self.requestV2(request, responseModel: FetchCheckInStatusResponse.self)
	}
}
