//
//  UpdateVoyageContractTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import Foundation

extension Endpoint {
	struct UpdateVoyageContractTask: Requestable {
		typealias RequestType = Request
		typealias QueryType = Query
		typealias ResponseType = Endpoint.GetReadyToSail.UpdateTask
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/voyagecontract"
		var method: Method = .put
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: Request?
		var query: Query?
		
		init(sign: Bool?, contractId: String, contractVersion: String, signForGuests: [String], reservation: VoyageReservation) {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			query = .init(guestId: sailor.reservationGuestId)
			request = .init(isCruiseContractSigned: sign, signedByReservationGuestId: reservation.reservationGuestId, signForOtherGuests: signForGuests, contractId: contractId, version: contractVersion)
		}
		
		struct Query: Encodable {
			var guestId: String // fe777d31-5993-4803-896b-07789fac5a74

			private enum CodingKeys: String, CodingKey {
				case guestId = "reservation-guest-id"
			}
		}
		
		struct Request: Encodable {
			var isCruiseContractSigned: Bool? // true
			var signedByReservationGuestId: String // "9ef030f9-e5c1-e611-80c5-00155df80332"
			var signForOtherGuests: [String] // []
			var contractId: String // "38492415-1ef4-476c-b058-3ca32304aaed"
			var version: String // "38492415-1ef4-476c-b058-3ca32304aaed"
		}
	}
}
