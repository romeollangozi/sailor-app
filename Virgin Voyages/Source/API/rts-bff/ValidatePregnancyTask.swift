//
//  ValidatePregnancyTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import Foundation

extension Endpoint {
	struct ValidatePregnancyTask: Requestable {
		typealias RequestType = Request
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/pregnancy/validate"
		var method: Method = .post
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: Request?
		var query: Query?
		
		init(numberOfWeeks: Int, reservation: VoyageReservation) {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			query = .init(guestId: sailor.id)
			request = .init(noOfWeeks: numberOfWeeks)
		}
		
		struct Query: Encodable {
			var guestId: String // fe777d31-5993-4803-896b-07789fac5a74

			private enum CodingKeys: String, CodingKey {
				case guestId = "reservation-guest-id"
			}
		}
		
		struct Request: Encodable {
			var noOfWeeks: Int // 8
		}
		
		struct Response: Decodable {
			var isFitToTravel: Bool // true
		}
	}
}
