//
//  GetTravelDocumentTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import Foundation

extension Endpoint {
	struct GetTravelDocumentTask: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/traveldocuments/v1"
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
			var guestId: String // 57f041d7-9b26-428c-860f-f6163b87264
			
			private enum CodingKeys: String, CodingKey {
				case guestId = "reservation-guest-id"
			}
		}
		
		struct Response: Decodable {
			var primaryDocumentOptions: [DocumentOption]
			var postCruiseInfo: PostCruiseInfo?
			var enablePostCruiseTab: Bool // true
			var additionalDocumentsOptions: [AdditionalDocumentOption]
			var travelDocumentsDetail: TravelDocumentsDetail

			struct DocumentOption: Decodable {
				var isSelected: Bool // false
				var documentTypeCode: String // "P"
			}

			struct PostCruiseInfo: Decodable {
				var flightDetails: FlightDetails?
				var showAsPrePopulatedFlight: Bool // true
				var isStayingIn: Bool // false
				var residenceName: String?
				var addressInfo: AddressInfo? // null
				var transportationTypeCode: String?
				
				struct AddressInfo: Decodable {
					var countryCode: String // "US"
					var city: String // "chicago"
					var line1: String // "L-10"
					var line2: String // "Gloden Lane"
					var zip: String // "301221"
					var stateCode: String // "AK"
					var addressTypeCode: String // "HOME"
					var isDeleted: Bool // false
				}

				struct FlightDetails: Decodable {
					var sequence: Int // 0
					var number: String? // "8760"
					var arrivalTime: String? // "17:15:00"
					var airlineCode: String? // "BA"
					var isOpted: Bool // true
				}
			}

			struct AdditionalDocumentOption: Decodable {
				var isSelected: Bool // false
				var entryPermitFor: String // "US"
				var documentTypeCode: String // "V"
			}

			struct TravelDocumentsDetail: Decodable {
				var identificationDocuments: [Document] // []
				var countryOfCitizenship: String? // "ES"
				var countryOfResidenceCode: String? // "US"
				var visaInfoList: [Visa] // []
				
				struct Document: Decodable {
					var documentTypeCode: String // "P"
					var documentPhotoUrl: String // "https:\/\/prod.virginvoyages.com\/dxpcore\/mediaitems\/949ff9ea-aed6-4941-b6b8-d65cbbc83096"
					var birthDate: String // "July 1 1990",
					var issueDate: String // "May 1 2020",
					var surname: String // "DESALVO"
					var givenName: String // "BOB SMITH"
					var isDeleted: Bool // false
					var identificationId: String // "3c90fb38-0249-48b0-b657-618936e1d538"
					var number: String // "A16178543"
					var birthCountryCode: String? // "US"
					var issueCountryCode: String // "US"
					var expiryDate: String // "May 1 2030",
					var backPhotoUrl: String // ""
					var gender: String // "M"
				}
				
				struct Visa: Decodable {
					let documentTypeCode: String // "V"
					let visaId: String
					let entriesCode: String? // "MULTIPLE"
					let issueDate: String
					let typeCode: String? // "SSCH"
					let surname: String
					let documentPhotoUrl: String
					let givenName: String
					let expiryDate: String
					let number: String
					let issueCountryCode: String // "ES"
					let backPhotoUrl: String // ""
					let visaEntries: String? // "MULTIPLE"
					let visaTypeCode: String? // "SSCH"
					let issuedFor: String // "ES"
				}
			}
		}
	}
}
