//
//  GetPregnancyTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import Foundation

extension Endpoint {
	struct GetPregnancyTask: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/pregnancy"
		var method: Method = .get
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: NoRequest?
		var query: Query?
		
		init(reservation: VoyageReservation) {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			query = .init(guestId: sailor.id)
		}
		
		// MARK: Query Data
		
		struct Query: Encodable {
			var guestId: String // fe777d31-5993-4803-896b-07789fac5a74

			private enum CodingKeys: String, CodingKey {
				case guestId = "reservation-guest-id"
			}
		}
		
		struct Response: Decodable {
			struct Buttons: Decodable {
				var no: String // "No"
				var yes: String // "Yes"
				var dontKnow: String // "I don't know"
			}
			
			struct Labels: Decodable {
				var weeks: String // "Weeks"
			}
			
			struct Page: Decodable {
				var title: String // "Are you pregnant?"
				var description: String // "Pregnant sailors are welcome onboard until the 24th week of their pregnancy."
			}
			
			struct PregnancyDetails: Decodable {
				var isPregnant: Bool? // true
				var noOfWeeks: Int? // 8
				var dontKnowFlag: Bool? // false
			}
			
			struct ReviewPage: Decodable {
				var title: String // "Pregnancy"
				var description: String // "You said you’re not pregnant."
				var caption: String // "Is this still true?"
				var imageURL: String // "https://dev.virginvoyages.com/svc/multimediastorage-service/mediaitems/c43f78ff-9969-4fb3-8585-cfc6edb404c0"
			}
			
			var requiredFields: [String] // ["pregnancyDetails.isPregnant"]
			var buttons: Buttons
			var labels: Labels
			var questionPage: Page
			var noOfWeeksPage: Page
			var notFitToTravelPage: Page
			var fitToTravelPage: Page
			var unKnownResponsePage: Page
			var pregnancyDetails: PregnancyDetails?
			var reviewPage: ReviewPage?
			var updateURL: String // "{rts-bff_base_url}/pregnancy?reservation-guest-id=12346"
		}
	}
}
