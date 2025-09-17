//
//  ValidateTravelDocumentTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import Foundation

extension Endpoint {
	struct ValidateTravelDocumentTask: Requestable {
		typealias RequestType = Endpoint.UpdateTravelDocumentTask.Request
		typealias QueryType = Endpoint.UpdateTravelDocumentTask.Query
        typealias ResponseType = Response?
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/traveldocuments/validate/v1"
		var method: Method = .post
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: RequestType?
		var query: QueryType?
		
		init(reservation: VoyageReservation) {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			query = .init(guestId: sailor.reservationGuestId)
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

        struct Response: Codable {
            var fieldErrors: [FieldError]?

            struct FieldError: Codable {
                var field: String
                var errorMessage: String
            }
        }
	}
}
