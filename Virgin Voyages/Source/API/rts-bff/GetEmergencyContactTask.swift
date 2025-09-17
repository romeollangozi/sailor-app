//
//  GetEmergencyContactTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/21/24.
//

import Foundation

extension Endpoint {
	struct GetEmergencyContactTask: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/emergencycontact"
		var method: Method = .get
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: NoRequest?
		var query: Query?
		
		init(reservation: VoyageReservation) {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			query = .init(guestId: sailor.reservationGuestId)
		}
		
		struct Query: Encodable {
			var guestId: String // a45c3a44-7d3a-41ac-809a-da3db915c350
			
			private enum CodingKeys: String, CodingKey {
				case guestId = "reservation-guest-id"
			}
		}
		
		struct Response: Decodable {
			var requiredFields: [String] // ["emergencyContactDetails.name", "emergencyContactDetails.relationship", "emergencyContactDetails.dialingCountryCode", "emergencyContactDetails.phoneNumber"]
			var optionalFields: [String] // []
			var readOnlyFields: [String] // []
			var hiddenFields: [String] // ["emergencyContact.emailId"]
			var labels: Labels
			var contactNamePage: Page
			var relationshipPage: Page
			var contactNumberPage: Page
			var reviewPage: Page
			var emergencyContactDetails: EmergencyContactDetails?
			var updateURL: String // "{rts-bff_base_url}/emergencycontact?reservation-guest-id=12346"
			var validateURL: String // "{rts-bff_base_url}/emergencycontact/validate?reservation-guest-id=12346"

			struct Labels: Decodable {
				var name: String // "Name"
				var relationship: String // "Relationship"
				var phoneCode: String // "Int."
				var phoneNumber: String // "Phone number"
			}

			struct Page: Decodable {
				var title: String // "WHO YA GONNA CALL?"
				var imageURL: String // "https://dev.virginvoyages.com/svc/multimediastorage-service/mediaitems/c43f78ff-9969-4fb3-8585-cfc6edb404c0"
			}

			struct EmergencyContactDetails: Decodable {
				var name: String? // "WILLIAM"
				var relationship: String? // "Uncle"
				var dialingCountryCode: String? // "CA"
				var phoneNumber: String? // "984747333"
			}
		}
	}
}
