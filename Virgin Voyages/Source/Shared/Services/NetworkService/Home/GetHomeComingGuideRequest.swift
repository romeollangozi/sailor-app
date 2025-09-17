//
//  GetHomeComingGuideRequest.swift
//  Virgin Voyages
//
//  Created by Pajtim on 2.4.25.
//

import Foundation

struct GetHomeComingGuideRequest: AuthenticatedHTTPRequestProtocol {
    var reservationGuestId: String,
		reservationId: String,
		debarkDate: String,
		shipCode: String,
		voyageNumber: String

    var path: String {
        return NetworkServiceEndpoint.getHomeComingGuide
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "reservationGuestId", value: reservationGuestId),
            .init(name: "reservationId", value: reservationId),
            .init(name: "debarkDate", value: debarkDate),
            .init(name: "shipCode", value: shipCode),
            .init(name: "voyageNumber", value: voyageNumber),
        ]
    }
}

struct GetHomeComingGuideResponse: Decodable {
    let header: HomeComingGuideHeader?
    let sections: [HomeComingGuideSection]?

    struct HomeComingGuideHeader: Decodable {
        let title: String?
        let description: String?
        let bannerImageUrl: String?
        let deck: String?
        let time: String?
        let queueDescription: String?
    }

    struct HomeComingGuideSection: Decodable {
        let title: String?
        let subtitle: String?
        let description: String?
        let bannerImageUrl: String?
    }
}

extension NetworkServiceProtocol {
	func getHomeComingGuide(reservationGuestId: String, reservationId: String, debarkDate: String, shipCode: String, voyageNumber: String) async throws -> GetHomeComingGuideResponse? {
		let request = GetHomeComingGuideRequest(reservationGuestId: reservationGuestId, reservationId: reservationId, debarkDate: debarkDate, shipCode: shipCode, voyageNumber: voyageNumber)
        return try await self.requestV2(request, responseModel: GetHomeComingGuideResponse.self)
    }
}
