//
//  GetMyVoyageAgendaRequest.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 5.3.25.
//

import Foundation

struct GetMyVoyageAgendaRequest: AuthenticatedHTTPRequestProtocol {
	let shipCode: String
	let reservationGuestId: String

	var path: String {
		return NetworkServiceEndpoint.myVoyageAgenda
	}

	var method: HTTPMethod {
		return .GET
	}

	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}

	var queryItems: [URLQueryItem]? {
		var items: [URLQueryItem] = [
			URLQueryItem(name: "shipCode", value: shipCode),
			URLQueryItem(name: "reservationGuestId", value: reservationGuestId)
		]
		return items
	}
}

struct GetMyVoyageAgendaRequestResponse: Decodable {
    let title: String?
    let appointments: [Appointment]?
    let emptyStateText: String?
    let emptyStatePictogramUrl: String?
    
    struct Appointment: Decodable {
        let location: String?
        let id: String?
        let inventoryState: String?
        let imageUrl: String?
        let timePeriod: String?
		let date: String?
        let bookableType: String?
        let name: String?
    }
}

extension NetworkServiceProtocol {
    func getMyVoyageAgenda(shipCode: String, reservationGuestId: String, cacheOption: CacheOption = .noCache()) async throws -> GetMyVoyageAgendaRequestResponse {
        let request = GetMyVoyageAgendaRequest(shipCode: shipCode, reservationGuestId:reservationGuestId)
        return try await self.requestV2(request, responseModel: GetMyVoyageAgendaRequestResponse.self, cacheOption: cacheOption)
    }
}
