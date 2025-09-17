//
//  SaveTravelDocumentModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 12.3.25.
//

import Foundation

// MARK: - SaveTravelDocument
struct SaveTravelDocumentInputModel: Equatable, Hashable {
    var countryOfResidenceCode: String
    var documentTypeCode: String
    var documentPhotoUrl: String
    var backPhotoUrl: String?
    var givenName: String
    var surname: String
    var birthDate: String
    var gender: String
    var number: String
    var expiryDate: String
    var issueDate: String
    var issueCountryCode: String
	var id: String?

    static func empty() -> SaveTravelDocumentInputModel {
        return SaveTravelDocumentInputModel(
            countryOfResidenceCode: "",
            documentTypeCode: "",
            documentPhotoUrl: "",
            backPhotoUrl: nil,
            givenName: "",
            surname: "",
            birthDate: "",
            gender: "",
            number: "",
            expiryDate: "",
            issueDate: "",
            issueCountryCode: "",
			id: nil
        )
    }
}


// MARK: - Sample Data for Testing
extension SaveTravelDocumentInputModel {
    static func sample() -> SaveTravelDocumentInputModel {
        return SaveTravelDocumentInputModel(
            countryOfResidenceCode: "AL",
            documentTypeCode: "P",
            documentPhotoUrl: "https://cert.gcpshore.virginvoyages.com/dxpcore/mediaitems/391b385b-ed87-4953-aae0-09589d061c7b",
            backPhotoUrl: nil,
            givenName: "A",
            surname: "B",
            birthDate: "December 3 1994",
            gender: "M",
            number: "BD0638610",
            expiryDate: "December 21 2030",
            issueDate: "December 22 2020",
            issueCountryCode: "AL"
        )
    }
}
