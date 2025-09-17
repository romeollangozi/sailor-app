//
//  UpdatePaymentMethodTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/8/24.
//

import Foundation

extension Endpoint {
	struct UpdatePaymentMethodTask: Requestable {
		typealias RequestType = Request
		typealias QueryType = Query
		typealias ResponseType = Endpoint.GetReadyToSail.UpdateTask
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/paymentmethod"
		var method: Method = .put
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: Request?
		var query: Query?
		
		init(paymentMethodCode: String, isDeleted: Bool, partyMembers: [Request.PartyMember], reservation: VoyageReservation, paymentToken: String = "") {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			query = .init(guestId: sailor.id, reservationId: sailor.reservationId)
			request = .init(selectedPaymentMethodCode: paymentMethodCode, cardPaymentToken: paymentToken, isDeleted: isDeleted, partyMembers: partyMembers)
		}
		
		struct Query: Encodable {
			var guestId: String // 57f041d7-9b26-428c-860f-f6163b87264
			var reservationId: String // 685850
			
			private enum CodingKeys: String, CodingKey {
				case guestId = "reservation-guest-id"
				case reservationId = "reservation-id"
			}
		}
		
		struct Request: Encodable {
			var selectedPaymentMethodCode: String
			var cardPaymentToken: String
			var isDeleted: Bool
			var partyMembers: [PartyMember]
			
			struct PartyMember: Codable {
				var reservationGuestId: String
				var isSelected: Bool
				var isDeleted: Bool
			}
		}
	}
}
