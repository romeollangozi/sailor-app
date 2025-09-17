//
//  HealthCheck.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/11/23.
//

import Foundation

extension Endpoint {
	struct GetHealthCheck: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/healthcheck"
		var method: Method = .get
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: NoRequest?
		var query: Query?
		
		init(reservation: VoyageReservation) {
			query = .init(guestId: reservation.reservationGuestId, reservationId: reservation.reservationId)
		}
		
		struct Query: Encodable {
			var guestId: String // fe777d31-5993-4803-896b-07789fac5a74
			var reservationId: String // a45c3a44-7d3a-41ac-809a-da3db915c350
			
			private enum CodingKeys: String, CodingKey {
				case reservationId = "reservation-id"
				case guestId = "reservation-guest-id"
			}
		}
		
		struct Response: Decodable {
			struct Buttons: Decodable {
			}
			
			struct LandingPage: Decodable {
				struct QuestionsPage: Decodable {
					struct HealthQuestion: Decodable {
						var questionCode: String // "ABC"
						var selectedOption: String // "YES"
						var title: String // "Question 1"
						var question: String // "Within the last 3 days, have you developed any symptoms of diarrhoea or vomiting?"
						var options: [String] // ["string"]
					}
					
					struct TravelParty: Decodable {
						struct PartyMember: Decodable {
							var imageURL: String // "https://dev.virginvoyages.com/svc/multimediastorage-service/mediaitems/c43f78ff-9969-4fb3-8585-cfc6edb404c0"
							var reservationGuestId: String // "123478"
							var name: String // "Bertie Apst"
							var genderCode: String // "M"
							var isAlreadySigned: Bool // true
						}
						
						var title: String // "Travel party"
						var description: String // "Let us know your shipmates are healthy by signing on their behalf."
						var alreadySignedTitle: String // "Already answered"
						var partyMembers: [PartyMember]
					}
					
					var healthQuestions: [HealthQuestion]
					var healthContract: String // "You answer “Yes”..."
					var travelParty: TravelParty
					var confirmationQuestion: String // "All good?"
				}
				
				var title: String // "Let us know you’re fit to sail"
				var description: String // "All our sailors must complete a pre-departure heath check..."
				var imageURL: String // "https://dev.virginvoyages.com/svc/multimediastorage-service/mediaitems/c43f78ff-9969-4fb3-8585-cfc6edb404c0"
				var questionsPage: QuestionsPage
			}
			
			struct HealthCheckPage: Decodable {
				var imageURL: String // "https://dev.virginvoyages.com/svc/multimediastorage-service/mediaitems/c43f78ff-9969-4fb3-8585-cfc6edb404c0"
				var title: String // "I’m sorry, but we need your health check"
				var description: String // "Nullam quis risus eget urna mollis ornare"
			}
			
			var buttons: Buttons
			var isHealthCheckComplete: Bool // true
			var isFitToTravel: Bool // true
			var landingPage: LandingPage
			var healthCheckRefusePage: HealthCheckPage
			var healthCheckReviewPage: HealthCheckPage?
			var updateURL: String // "{rts-bff_base_url}/healthcheck?reservation-guest-id=12346"
			var downloadContractFileUrl: String // "https://{dxc-core-public-url}/downloadcontract?contractType=HC&reservationGuestId=4bc31ef8-55f5-4d28-88e0-7735bcb43d58\""
		}
	}
}

// MARK: Extensions

extension Endpoint.GetHealthCheck.Response.LandingPage.QuestionsPage.HealthQuestion: Identifiable {
	var id: String {
		questionCode
	}
}
