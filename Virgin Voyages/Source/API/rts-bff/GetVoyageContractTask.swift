//
//  GetVoyageContractTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import Foundation

extension Endpoint {
	struct GetVoyageContractTask: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/voyagecontract"
		var method: Method = .get
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: NoRequest?
		var query: Query?
		
		init(reservation: VoyageReservation) {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			query = .init(guestId: sailor.reservationGuestId, reservationId: sailor.reservationId)
		}
		
		// MARK: Query Data
		
		struct Query: Encodable {
			var guestId: String // 57f041d7-9b26-428c-860f-f6163b87264
			var reservationId: String // 685850
			
			private enum CodingKeys: String, CodingKey {
				case guestId = "reservation-guest-id"
				case reservationId = "reservation-id"
			}
		}
		
		struct Response: Decodable {
			var contractStartPage: ContractStartPage
			var contractContent: ContractContent // "Placeholder for voyage contract..."
			var dependentPage: DependentPage
			var contractReviewPage: ContractReviewPage?
			var contractDenyPage: ContractDenyPage
			var contractDetails: ContractDetails
			var version: String // "38492415-1ef4-476c-b058-3ca32304aaed"
			var contractId: String // "38492415-1ef4-476c-b058-3ca32304aaed"
			var updateURL: String // "{rts-bff_base_url}/voyagecontract?reservation-guest-id=12346"
			var downloadContractFileUrl: String // "https://{dxc-core-public-url}/downloadcontract?contractType=HC&reservationGuestId=4bc31ef8-55f5-4d28-88e0-7735bcb43d58\""

			struct ContractContent: Decodable {
				var name: String // "Voyage-Contract"
				var fullContent: String // " "
				var footer: String // ""
				var title: String // "RTS Voyage Contract"
				var blocks: [Block]

				struct Block: Decodable {
					var title: String?
					var subtitle: String? 
					var body: String // "Please review your ticket contract. This Ticket Contract..."
					var id: String // "e731d211-2c09-4e71-bd9f-54a4574be0a0"
					var nodeType: String // "mgnl:contentNode"
				}
			}

			struct ContractStartPage: Decodable {
				var title: String // "Voyage Contract"
				var description: String // "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
				var imageURL: String // "https://dev.virginvoyages.com/svc/multimediastorage-service/mediaitems/c43f78ff-9969-4fb3-8585-cfc6edb404c0"
			}

			struct DependentPage: Decodable {
				var title: String // "Sign on behalf of"
				var description: String // "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
				var alreadySignedTitle: String // "Already signed"
				var question: String // "All good?"
			}

			struct ContractReviewPage: Decodable {
				var title: String // "Voyage contract"
				var description: String // "You signed on"
				var imageURL: String // "https://dev.virginvoyages.com/svc/multimediastorage-service/mediaitems/c43f78ff-9969-4fb3-8585-cfc6edb404c0"
				var question: String // "All good?"
			}

			struct ContractDenyPage: Decodable {
				var title: String // "Voyage contract"
				var description: String // "Unfortunately you have to agree to our voyage contract to sail with us. Please get in touch regarding your concern."
				var imageURL: String // "https://dev.virginvoyages.com/svc/multimediastorage-service/mediaitems/c43f78ff-9969-4fb3-8585-cfc6edb404c0"
				var buttonCaption: String // "Contact Virgin"
			}

			struct ContractDetails: Decodable {
				var isCruiseContractSigned: Bool // true
				var contractSignedDate: String? // "2020-06-20"
				var otherGuestList: [OtherGuest] // []
				var signedContractId: String? // "38492415-1ef4-476c-b058-3ca32304aaed"
				var signedCruiseContractVersion: String? // "38492415-1ef4-476c-b058-3ca32304aaed"

				struct OtherGuest: Decodable {
					var imageURL: String // "https://dev.virginvoyages.com/svc/multimediastorage-service/mediaitems/c43f78ff-9969-4fb3-8585-cfc6edb404c0"
					var reservationGuestId: String // "123478"
					var name: String // "Bertie Apst"
					var genderCode: String // "M"
					var isAlreadySigned: Bool // true
				}
			}
		}
	}
}
