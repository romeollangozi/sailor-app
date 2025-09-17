//
//  HealthSubmit.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/11/23.
//

import Foundation

extension Endpoint {
	struct UpdateHealthCheck: Requestable {
		typealias RequestType = Request
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/healthcheck"
		var method: Method = .put
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: Request?
		var query: Query?
		
		init(answers: [Request.HealthQuestion], reservation: VoyageReservation) {
			query = .init(reservationId: reservation.reservationId, guestId: reservation.reservationGuestId)
			request = .init(healthQuestions: answers, signForOtherGuests: [])
		}
		
		// MARK: Request Data
		
		struct Request: Encodable {
			struct HealthQuestion: Encodable {
				var questionCode: String // "UI003120"
				var selectedOption: String // "NO"
			}
			
			var healthQuestions: [HealthQuestion]
			var signForOtherGuests: [String]
		}
		
		// MARK: Query Data
		
		struct Query: Encodable {
			var reservationId: String // a45c3a44-7d3a-41ac-809a-da3db915c350
			var guestId: String // fe777d31-5993-4803-896b-07789fac5a74
			
			private enum CodingKeys: String, CodingKey {
				case reservationId = "reservation-id"
				case guestId = "reservation-guest-id"
			}
		}
		
		struct Response: Decodable {
			struct HealthCheckFailedPage: Decodable {
				var imageURL: String // "https://dev.virginvoyages.com/svc/multimediastorage-service/mediaitems/c43f78ff-9969-4fb3-8585-cfc6edb404c0"
				var title: String // "Oh no! We had to reject your health check"
				var description: String // "But don’t worry, this doesn’t mean you won’t be able to sail. We’ll give you a call very soon discuss your check further."
			}
			
			var healthCheckFailedPage: HealthCheckFailedPage?
			var isHealthCheckComplete: Bool // true
			var isFitToTravel: Bool // true
		}
	}
}
