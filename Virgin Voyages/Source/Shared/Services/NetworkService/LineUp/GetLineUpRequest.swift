//
//  GetLineUp.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 21.1.25.
//

import Foundation

struct GetLineUpRequest: AuthenticatedHTTPRequestProtocol {
	let reservationGuestId: String
	let startDateTime: String?
	let voyageNumber: String
	let reservationNumber: String

	var path: String {
		return NetworkServiceEndpoint.lineUp
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
			.init(name: "reservationNumber", value: self.reservationNumber)
		]

		if let startDateTime = self.startDateTime {
			items.append(.init(name: "startDateTime", value: startDateTime))
		}

		return items
	}
}

struct GetLineUpRequestResponse: Decodable {

    let leadTime: LeadTime?
    let events: [LineUpEvent]?
    let mustSeeEvents: [LineUpEvent]?
    
    struct LineUpEvent: Decodable {
		let sequence: Int?
        let time: String?
        let date: String?
        let items: [EventItemResponse]?
    }
    
    struct LeadTime: Decodable {
        let title: String?
        let description: String?
        let imageUrl: String?
        let date: String?
        let isCountdownStarted: Bool?
        let timeLeftToBookingStartInSeconds: Int?
    }
}

extension NetworkServiceProtocol {
    func getLineUp(reservationGuestId: String,
                   startDateTime: String? = nil,
                   voyageNumber: String,
                   reservationNumber: String,
				   cacheOption: CacheOption = .noCache()
    ) async throws -> GetLineUpRequestResponse {
        
        let request = GetLineUpRequest(reservationGuestId: reservationGuestId,
                                       startDateTime: startDateTime,
                                       voyageNumber:voyageNumber,
                                       reservationNumber: reservationNumber)
        
		return try await self.requestV2(request, responseModel: GetLineUpRequestResponse.self, cacheOption: cacheOption)
    }
}
