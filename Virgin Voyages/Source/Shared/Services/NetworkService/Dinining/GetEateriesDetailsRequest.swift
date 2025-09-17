//
//  GetEateriesDetailsRequest.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 30.11.24.
//

import Foundation

struct GetEateriesDetailsRequest: AuthenticatedHTTPRequestProtocol {
    let slug: String
    let reservationId: String
    let reservationGuestId: String
    let shipCode: String
    
    var path: String {
        return "\(NetworkServiceEndpoint.eateriesDetails)/\(slug)/details"
    }
    var method: HTTPMethod {
        return .GET
    }
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        let reservationId: URLQueryItem = .init(name: "reservation-id", value: self.reservationId)
        let reservationGuestId: URLQueryItem = .init(name: "reservation-guest-id", value: self.reservationGuestId)
        let shipCode: URLQueryItem = .init(name: "shipCode", value: self.shipCode)
		let isDiningSplashV2: URLQueryItem = .init(name: "isDiningSplashV2", value: "true")
        return [reservationId, reservationGuestId, shipCode, isDiningSplashV2]
    }
}

struct GetEateriesDetailsResponse: Codable {
    let name: String?
    let deckLocation: String?
    let portraitHeroURL: String?
    let externalId: String?
    let introduction: String?
    let longDescription: String?
    let dividerColor: String?
    let needToKnowsColor: String?
    let needToKnows: [String]?
    let editorialBlocks: [String]?
    let featuredEventsCategoryCode: String?
    let virtualQueuesBackgroundImage: String?
    let bannerBgColor: String?
    let bannerTextColor: String?
    let categoryCode: String?
    let isFavourite: Bool?
    let spaceCurrentStatus: SpaceCurrentStatus?
    let operationalHours: [OperationalHour]?
    let openingTimes: [OpeningTime]?
    let menuData: MenuData?

    struct MenuData: Codable {
        let menuFooterColor: String?
        let description: String?
        let menuTextColor: String?
        let coverDescription: String?
        let pageBackground: String?
        let coverImage: String?
        let name: String?
        let header: String?
        let logo: String?
        let id: String?
        let menuPdf: String?
    }

    struct SpaceCurrentStatus: Codable {
        let label: String?
    }
    
    struct OperationalHour: Codable {
        let fromDate: String?
        let toDate: String?
        let fromTime: String?
        let toTime: String?
    }
    
    struct OpeningTime: Codable {
        let label: String?
        let text: String?
    }
    
}

extension NetworkServiceProtocol {
	func getEateriesDetails(slug: String, reservationId: String, reservationGuestId: String, shipCode: String, cacheOption: CacheOption) async throws -> GetEateriesDetailsResponse? {
        let request = GetEateriesDetailsRequest(slug: slug, reservationId: reservationId, reservationGuestId: reservationGuestId, shipCode: shipCode)
		return try await self.requestV2(request, responseModel: GetEateriesDetailsResponse.self, cacheOption: cacheOption)
    }
}
