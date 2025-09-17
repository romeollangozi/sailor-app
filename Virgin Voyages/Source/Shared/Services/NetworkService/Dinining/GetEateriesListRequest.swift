//
//  GetEateriesList.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 23.11.24.
//

import Foundation

struct GetEateriesListRequest: AuthenticatedHTTPRequestProtocol {
	let reservationId: String
	let reservationGuestId: String
	let shipCode: String
	let reservationNumber: String
	let includePortsName: Bool

	var path: String {
		return NetworkServiceEndpoint.eateriesList
	}
	var method: HTTPMethod {
		return .GET
	}
	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}
	var queryItems: [URLQueryItem]? {
		let reservationId: URLQueryItem = .init(name: "reservationId", value: self.reservationId)
		let reservationGuestId: URLQueryItem = .init(name: "reservationGuestId", value: self.reservationGuestId)
		let shipCode: URLQueryItem = .init(name: "shipCode", value: self.shipCode)
		let reservationNumber: URLQueryItem = .init(name: "reservationNumber", value: self.reservationNumber)
		let includePortsName: URLQueryItem = .init(name: "includePortsName", value: self.includePortsName ? "true" : "false")
		let isDiningSplashV2: URLQueryItem = .init(name: "isDiningSplashV2", value: "true")
		return [reservationId, reservationGuestId, shipCode, reservationNumber, includePortsName, isDiningSplashV2]
	}
}

struct GetEateriesListRequestResponse: Codable {
	struct Eatery: Codable {
		let name: String?
		let externalId: String?
		let priority: String?
		let actionUrl: String?
		let squareThumbnailUrl: String?
		let deckLocation: String?
		let label: String?
		let portraitHeroUrl: String?
		let introduction: String?
		let venueId: String?
		let slug: String?

		enum CodingKeys: String, CodingKey {
			case name
			case externalId
			case priority
			case actionUrl
			case squareThumbnailUrl
			case deckLocation
			case label
			case portraitHeroUrl
			case introduction
			case venueId = "VenueId"
			case slug
		}
	}

	let bookable: [Eatery]?
	let walkIns: [Eatery]?
	let guestCount: Int?
	let isPreVoyageBookingStopped: Bool?
	let leadTime: LeadTime?
	let cmsContent: CMSContent?

	struct CMSContent: Codable {
		struct Text: Codable {
			let preVoyageBookingStoppedTitle: String?
			let preVoyageBookingStoppedDescription: String?
            let partySizeInfoDrawerBody: String?
            let partySizeInfoDrawerHeading: String?
            let diningReservationsShipboardModalHeading: String?
            let diningReservationsShipboardModalSubHeading: String?
            let diningReservationsShipboardModalSubHeading1: String?
            let diningReservationsPreCruiseModalHeading: String?
            let soldOutReadMore: String?
            let gotItCta: String?
            let selectTimeSlotSubheading: String?
		}

		let text: Text?
	}

	struct LeadTime: Codable {
		let title: String?
		let subtitle: String?
		let description: String?
		let date: String?
		let upgradeClassUrl: String?
		let isCountdownStarted: Bool?
	}
}

extension NetworkServiceProtocol {
	func getEateriesList(reservationId: String, reservationGuestId: String, shipCode: String, reservationNumber: String, includePortsName: Bool, cacheOption: CacheOption) async throws -> GetEateriesListRequestResponse? {
		let request = GetEateriesListRequest(reservationId: reservationId, reservationGuestId: reservationGuestId, shipCode: shipCode, reservationNumber:reservationNumber, includePortsName: includePortsName)

		return try await self.requestV2(request, responseModel: GetEateriesListRequestResponse.self, cacheOption: cacheOption)
	}
}
