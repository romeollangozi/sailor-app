//
//  GetSignature.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/21/24.
//

import Foundation

extension Endpoint {

	struct GetPaymentPage: Requestable {
		typealias RequestType = Request
		typealias QueryType = NoQuery
		typealias ResponseType = GetPaymentPage.Response
		var authenticationType: AuthenticationType = .user
        var path = "/rts-bff/vpspayment"
		var method: Method = .post
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: Request?
		var query: NoQuery?

		struct Request: Encodable {
			var consumerId: String
			var consumerType: String
			var currency: String
			var bookingId: Int
		}

		init(reservation: VoyageReservation) {
            let sailor = reservation.assistingSailor ?? reservation.primarySailor
			let reservationGuestId = sailor.reservationGuestId
			let consumerType = "DXPReservationGuestId"
            let reservationNumber = Int(sailor.reservationNumber) ?? 0
			request = .init(consumerId: reservationGuestId, consumerType: consumerType, currency: "USD", bookingId: reservationNumber)
		}

		// This is embedded in the HTML of the web page
		struct Response: Decodable {
			let paymentToken: String
			let expiresIn: Int
			let links: Links

			enum CodingKeys: String, CodingKey {
				case paymentToken = "payment_token"
				case expiresIn = "expires_in"
				case links = "_links"
			}

			struct Links: Decodable {
				let paymentTokenStatus: Link
				let form: Link

				struct Link: Decodable {
					let href: URL
				}
			}
		}
	}
}
