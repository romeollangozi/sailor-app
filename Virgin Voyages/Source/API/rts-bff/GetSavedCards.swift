//
//  GetSavedCards.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/16/23.
//

import Foundation

extension Endpoint {
	struct GetSavedCards: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = NoQuery
		typealias ResponseType = [Response]
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/savedcards"
		var method: Method = .get
		var cachePolicy: CachePolicy = .none
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: NoRequest?
		var query: NoQuery?
		
		struct Response: Codable {
			var cardExpiryYear: String // "24"
			var receiptReference: String // "765ed3c1-2c21-4cb1-b522-ad1bc0ec02a8"
			var zipcode: String? // "32259"
			var paymentToken: String // "5f226efe-155b-4d4e-bb52-95aa311047eb"
			var cardMaskedNo: String // "425908******4466"
			var billToCity: String? // "Saint Johns"
			var billToLine1: String? // "469 Albany Bay Blvd"
			var billToLine2: String? // ""
			var shipToCity: String? // "Saint Johns"
			var shipToFirstName: String?
			var shipToLastName: String?
			var name: String // "Chris DeSalvo"
			var billToState: String? // "FL"
			var cardType: String // "001"
			var billToFirstName: String? // "Chris"
			var billToLastName: String? // "DeSalvo"
			var billToZipCode: String? // "32259"
			var shipToLine1: String? // "469 Albany Bay Blvd"
			var shipToLine2: String? // ""
			var tokenProvider: String? // "fexco"
			var shipToZipCode: String? // "32259"
			var cardExpiryMonth: String? // "10"
			var shipToState: String? // "FL"
		}
	}
}
