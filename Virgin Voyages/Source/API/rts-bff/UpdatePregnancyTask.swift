//
//  UpdatePregnancyTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import Foundation

extension Endpoint {
	struct UpdatePregnancyTask: Requestable {
		typealias RequestType = Request
		typealias QueryType = Query
		typealias ResponseType = Endpoint.GetReadyToSail.UpdateTask
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/pregnancy"
		var method: Method = .put
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: Request?
		var query: Query?
		
		init(pregnant: Bool? = nil, weeks: Int? = nil, reservation: VoyageReservation) {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			query = .init(guestId: sailor.id)
			request = .init(pregnancyDetails: .init(isPregnant: pregnant, noOfWeeks: weeks, dontKnowFlag: pregnant == true && weeks == nil))
		}
		
		struct Query: Encodable {
			var guestId: String // fe777d31-5993-4803-896b-07789fac5a74

			private enum CodingKeys: String, CodingKey {
				case guestId = "reservation-guest-id"
			}
		}
		
		struct Request: Encodable {
			var pregnancyDetails: Pregnancy
			
			struct Pregnancy: Encodable {
				var isPregnant: Bool? // true
				var noOfWeeks: Int? // 8
				var dontKnowFlag: Bool? // false
			}
		}
	}
}
