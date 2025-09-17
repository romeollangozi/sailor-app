//
//  GetTravelDocumentData.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/22/24.
//

import Foundation

extension Endpoint {
	struct GetTravelDocumentData: Requestable {
		typealias RequestType = Request
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/traveldocuments/ocr"
		var method: Method = .post
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: Request?
		var query: Query?
		
		init(photoData: Data, documentType: TravelDocumentTask.DocumentType, reservation: VoyageReservation) {
			pathComponent = documentType.path
			query = .init()
			request = .init(photoContent: photoData.base64EncodedString())
		}
		
		struct Query: Encodable {
		}
		
		struct Request: Encodable {
			var photoContent: String
		}
		
		struct Response: Decodable {
			var number: String? // "37698001"
			var surname: String? // "Jones"
			var givenName: String? // "David Robert"
			var gender: String? // "M:
			var birthCountryCode: String? // "UK"
			var issueCountryCode: String? // "EN"
			var birthDate: String? 
			var issueDate: String? // "July 26 2013"
			var expiryDate: String? // "July 26 2020"
		}
	}
}
