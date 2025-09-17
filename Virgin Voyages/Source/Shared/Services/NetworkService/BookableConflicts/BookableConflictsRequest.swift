//
//  GetMyVoyageAddOnsRequest.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 11.3.25.
//


import Foundation

struct BookableConflictsRequest: AuthenticatedHTTPRequestProtocol {

	let input: BookableConflictsRequestBody

	var path: String {
		return NetworkServiceEndpoint.bookableConflicts
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

struct BookableConflictsRequestBody: Codable {
	let sailors: [Sailor]?
	let slots: [Slot]?
	let activityCode: String?
	let voyageNumber: String?
	let isActivityPaid: Bool?
	let activityGroupCode: String?
	let shipCode: String
    let appointmentLinkId: String
	
	struct Sailor: Codable {
		let reservationNumber: String
		let reservationGuestId: String
	}

	struct Slot: Codable {
		let code: String
		let startDateTime: String
		let endDateTime: String
	}
}

struct BookableConflictsResponse: Decodable {
	let slotId: String?
	let slotStatus: String?
	let sailors: [Sailor]?

	struct Sailor: Decodable {
		let reservationGuestId: String?
		let status: String?
		let bookableType: String?
		let appointmentId: String?
	}
}


extension NetworkServiceProtocol {
	func getBookableConflicts(input: BookableConflictsRequestBody) async throws -> [BookableConflictsResponse]? {
		let request = BookableConflictsRequest(input: input)
		let response =  try await self.requestV2(request, responseModel: [BookableConflictsResponse].self)
		return response
	}
}
