//
//  UpdateFlight.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/21/24.
//

import Foundation

extension Endpoint {
	struct UpdateFlight: Requestable {
		typealias RequestType = Request
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/flight"
		var method: Method = .put
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: Request?
		var query: Query?

        init(task: EmbarkationTask, reservation: VoyageReservation) {
            let sailor = reservation.assistingSailor ?? reservation.primarySailor
            query = .init(reservationId: sailor.reservationId, guestId: sailor.reservationGuestId)
            request = task.updateInboundFlight
        }

		struct Query: Encodable {
			var reservationId: String // a45c3a44-7d3a-41ac-809a-da3db915c350
			var guestId: String // fe777d31-5993-4803-896b-07789fac5a74
			
			private enum CodingKeys: String, CodingKey {
				case reservationId = "reservation-id"
				case guestId = "reservation-guest-id"
			}
		}
		
		struct Request: Encodable {
			var flightDetails: FlightDetails
			var isFlyingIn: Bool // true

			struct FlightDetails: Encodable {
				var airlineCode: String // "AB"
				var number: String // "1965"
                var arrivalTime: String? // "10:30:00"
                var departureAirportCode: String? // "DIA"
                var arrivalAirportCode: String? // "MIA"
                var departureTime: String? // "08:00:00"
				var sequence: Int? // 1
			}
		}
		
		struct Response: Decodable {
            var availableSlots: [Endpoint.GetEmbarkationSlotTask.Response.Slot]
		}
	}
}
