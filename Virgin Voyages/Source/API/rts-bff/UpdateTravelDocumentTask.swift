//
//  UpdateTravelDocumentTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import Foundation

extension Endpoint {
	struct UpdateTravelDocumentTask: Requestable {
		typealias RequestType = Request
		typealias QueryType = Query
		typealias ResponseType = Endpoint.GetReadyToSail.UpdateTask
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/traveldocuments/v1"
		var method: Method = .put
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: Request?
		var query: Query?
		
		enum Mode {
			case update
			case validate
			
			var path: String {
				switch self {
				case .update: "v1"
				case .validate: "validate"
				}
			}
		}
		
		init(request: Request, reservation: VoyageReservation) {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			self.query = .init(guestId: sailor.reservationGuestId)
			self.request = request
		}
		
		init(passport: TravelDocumentTask.Passport, photoUrl: URL, delete: Bool = false, reservation: VoyageReservation) {			
			self.query = .init(guestId: reservation.reservationGuestId)
			let expiryDate = passport.expiryDate.format(.travelDocument)
			let issueDate = passport.issueDate.format(.travelDocument)
			let birthDate = passport.birthDate.format(.travelDocument)
			let documentPhotoUrl = photoUrl.absoluteString
			let documentTypeCode = TravelDocumentTask.DocumentType.passport.id
			let document: Endpoint.UpdateTravelDocumentTask.Request.TravelDocumentsDetail.IdentificationDocument = .init(documentTypeCode: documentTypeCode, isDeleted: delete, documentPhotoUrl: documentPhotoUrl, backPhotoUrl: "", givenName: passport.givenName, surname: passport.surname, birthDate: birthDate, gender: passport.gender, number: passport.number, expiryDate: expiryDate, issueDate: issueDate, issueCountryCode: passport.issueCountryCode, birthCountryCode: passport.birthCountryCode)
			request = .init(travelDocumentsDetail: .init(countryOfResidenceCode: passport.countryOfResidenceCode, identificationDocuments: [document]))
		}
		
		init(visa: TravelDocumentTask.Visa, photoUrl: URL, delete: Bool = false, reservation: VoyageReservation) {
			self.query = .init(guestId: reservation.reservationGuestId)
			let expiryDate = visa.expiryDate.format(.travelDocument)
			let issueDate = visa.issueDate.format(.travelDocument)
			let documentPhotoUrl = photoUrl.absoluteString
			let documentTypeCode = TravelDocumentTask.DocumentType.visaCode
			let document: Endpoint.UpdateTravelDocumentTask.Request.TravelDocumentsDetail.VisaInfo = .init(documentTypeCode: documentTypeCode, isDeleted: delete, documentPhotoUrl: documentPhotoUrl, backPhotoUrl: "", visaCategoryId: "", documentCategoryCode: "", visaTypeCode: visa.typeCode, number: visa.number, issueDate: issueDate, expiryDate: expiryDate, issueCountryCode: visa.issueCountryCode, visaEntries: visa.entriesCode, givenName: visa.givenName, surname: visa.surname)
			request = .init(travelDocumentsDetail: .init(countryOfResidenceCode: "", visaInfoList: [document]))
		}
		
		init(postVoyage: Request.PostCruiseInfo, reservation: VoyageReservation) {
			self.query = .init(guestId: reservation.reservationGuestId)
			request = .init(postCruiseInfo: postVoyage)
		}
		
		init(reservation: VoyageReservation) {
			self.query = .init(guestId: reservation.reservationGuestId)
			request = .init(postCruiseInfo: .init())
		}
		
		// MARK: Query Data
		
		struct Query: Encodable {
			var guestId: String // 57f041d7-9b26-428c-860f-f6163b87264
			
			private enum CodingKeys: String, CodingKey {
				case guestId = "reservation-guest-id"
			}
		}
		
		struct Request: Encodable {
			var postCruiseInfo: PostCruiseInfo?
			var travelDocumentsDetail: TravelDocumentsDetail?
			
			struct TravelDocumentsDetail: Encodable {
				var countryOfResidenceCode: String
				var identificationDocuments: [IdentificationDocument]?
				var visaInfoList: [VisaInfo]?
				
				struct IdentificationDocument: Encodable {
					var documentTypeCode: String
					var isDeleted: Bool
					var documentPhotoUrl: String
					var backPhotoUrl: String
					var givenName: String
					var surname: String
					var birthDate: String
					var gender: String
					var number: String
					var expiryDate: String
					var issueDate: String
					var issueCountryCode: String
					var birthCountryCode: String
				}
				
				struct VisaInfo: Codable {
					var documentTypeCode: String
					var isDeleted: Bool
					var documentPhotoUrl: String
					var backPhotoUrl: String
					var visaCategoryId: String
					var documentCategoryCode: String
					var visaTypeCode: String
					var number: String
					var issueDate: String
					var expiryDate: String
					var issueCountryCode: String
					var visaEntries: String
					var givenName: String
					var surname: String
					var visaId: String?
				}
			}
			
			struct PostCruiseInfo: Encodable {
				var transportationTypeCode: String? // "AIR"
				var isStayingIn: Bool? // false
				var flightDetails: FlightDetails?
				
				struct FlightDetails: Encodable {
					var number: String // "1642"
					var airlineCode: String // "AA"
					var departureAirportCode: String // "MIA"
				}
				
				struct AddressInfo: Encodable {
					var countryCode: String // "US"
					var city: String // "chicago"
					var line1: String // "L-10"
					var line2: String // "Gloden Lane"
					var zip: String // "301221"
					var stateCode: String // "AK"
					var addressTypeCode: String // "HOME"
					var isDeleted: Bool // false
				}
			}
		}
	}
}
