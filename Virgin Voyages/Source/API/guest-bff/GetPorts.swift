//
//  DiscoverPorts.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/15/23.
//

import Foundation

extension Endpoint {
	struct GetPorts: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/guest-bff/discover/discover/ports/landing"
		var method: Method = .get
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .any
		var pathComponent: String?
		var request: NoRequest?
		var query: Query?
		
		init(reservation: VoyageReservation) {
			query = .init(reservationId: reservation.reservationId, guestId: reservation.reservationGuestId, shipCode: reservation.shipCode)
		}
		
		init(reservationId: String, reservationGuestId: String, shipCode: CruiseShip) {
			query = .init(reservationId: reservationId, guestId: reservationGuestId, shipCode: shipCode)
		}
		
		// MARK: Query Data
		
		struct Query: Encodable {
			var reservationId: String // a45c3a44-7d3a-41ac-809a-da3db915c350
			var guestId: String // fe777d31-5993-4803-896b-07789fac5a74
			var shipCode: CruiseShip
			
			private enum CodingKeys: String, CodingKey {
				case reservationId = "reservation-id"
				case guestId = "reservation-guest-id"
				case shipCode
			}
		}
		
		// MARK: Response Data
		
		struct Response: Decodable {
			struct DestinationCard: Decodable, Hashable {
				var portName: String? // "Miami"
				var portCode: String // "MIA"
				var arrivalTime: String?
				var departureTime: String? // "2023-04-19T18:00:00"
				var tabLabel: String // "MIA"
				var sequence: Int // 0
				var cardSubHeader: String? // "Your Miami Guide"
				var arrivalDateTime: String // "April 19th, DEPARTING 6.00pm"
				var excursionsBtnActionURL: String // "https:\/\/prod.virginvoyages.com\/guest-bff\/ars\/v2\/activities\/MIA"
				var journeyImageURL: String? // ""
				var actionURL: String? // ":
			}
            
            struct LeadTime: Decodable, Hashable {
                   let title: String?
                   let description: String?
                   let imageUrl: String?
                   let date: String?
                   let isCountdownStarted: Bool?
                   let timeLeftToBookingStartInSeconds: Int?
               }
			
			var destinationCardCarousel: [DestinationCard]
			var backActionURL: String // ""
			var backButtonIconImageURL: String // ""
            var leadTime: LeadTime?
		}
	}
}

extension Endpoint.GetPorts.Response.DestinationCard {
	func toModel() -> DestinationCard {
		return DestinationCard(portName: portName ?? "",
							   portCode: portCode,
							   arrivalTime: arrivalTime,
							   departureTime: departureTime,
							   tabLabel: tabLabel,
							   sequence: sequence,
							   cardSubHeader: cardSubHeader,
							   arrivalDateTime: arrivalDateTime,
							   excursionsBtnActionURL: excursionsBtnActionURL,
							   journeyImageURL: journeyImageURL,
							   actionURL: actionURL
        )
	}
}

extension Endpoint.GetPorts.Response.LeadTime {
    func toDomain() -> LeadTime {
        return LeadTime(
            title: title.value,
            description: description.value,
            imageUrl: imageUrl.value,
            date: date?.iso8601 ?? Date(),
            isCountdownStarted: isCountdownStarted ?? false,
            timeLeftToBookingStartInSeconds: timeLeftToBookingStartInSeconds.value
        )
    }
}
