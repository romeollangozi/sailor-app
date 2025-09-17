//
//  UpdateEmergencyContactTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/21/24.
//

import Foundation

extension Endpoint {
	struct UpdateEmergencyContactTask: Requestable {
		typealias RequestType = Request
		typealias QueryType = Query
		typealias ResponseType = Endpoint.GetReadyToSail.UpdateTask
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/emergencycontact"
		var method: Method = .put
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: Request?
		var query: Query?
		
		init(emergencyContact: Request.EmergencyContactDetails, reservation: VoyageReservation) {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			query = .init(guestId: sailor.id)
			request = .init(emergencyContactDetails: emergencyContact)
		}
		
		struct Query: Encodable {
			var guestId: String // a45c3a44-7d3a-41ac-809a-da3db915c350
			
			private enum CodingKeys: String, CodingKey {
				case guestId = "reservation-guest-id"
			}
		}
		
		struct Request: Encodable {
			var emergencyContactDetails: EmergencyContactDetails

			struct EmergencyContactDetails: Encodable {
				var name: String // "WILLIAM"
				var relationship: String // "Uncle"
				var dialingCountryCode: String // "CA"
				var phoneNumber: String // "984747333"
			}
		}
	}
}
