//
//  TravelDocumentDetails.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 4.3.25.
//

import Foundation
import VVUIKit

// MARK: - TravelDocumentDetails
struct TravelDocumentDetails: Equatable, Hashable {
    let title: String
    let description: String
    let id: String
    let moderationErrors: [String]
    var fields: [Field]
    let isScanable: Bool
    let isCapturable: Bool
    let isTwiceSide: Bool
    let scanFormatType: ScanType
    let isAlreadyUploaded: Bool
    let documentExpirationWarnConfig: DocumentExpirationWarnConfig?
    let documentCombinedRules: [DocumentCombinedRule]


    struct Field: Identifiable, Equatable, Hashable {
        var id: String
        var label: String
        var name: String
        var type: FieldType
        var value: String
        var readonly: Bool
        var hidden: Bool
        var required: Bool
        var isSecure: Bool
        var referenceName: String
        var maskedValue: String?
        var errorMessage: String?

        static func empty() -> Field {
            return Field(
                id: UUID().uuidString,
                label: "",
                name: "",
                type: .string,
                value: "",
                readonly: false,
                hidden: false,
                required: false,
                isSecure: false,
                referenceName: "",
                maskedValue: nil,
                errorMessage: nil
            )
        }
    }
    
    struct DocumentExpirationWarnConfig: Equatable, Hashable {
        let documentExpirationInMonths: Int?
        let title: String?
        let description: String?
    }
    
    struct DocumentCombinedRule: Codable, Equatable, Hashable {
        let sourceDocumentType: String?
        let destinationDocumentType: String?
        let field: String?
        let saveType: String?
    }
}

// MARK: - Enums
enum ScanType: String, Equatable {
    case nonScanabled = "NonScanabled"
    case passportOrVisa = "PassportOrVisa"
    case cardFormatMrz = "CardFormatMrz"
    case cardFormatTwoSides = "CardFormatTwoSides"
    case capturable = "Capturable"
}

enum FieldType: String, Equatable {
    case number = "Number"
    case string = "String"
    case date = "Date"
    case dropdown = "Dropdown"
    case image = "Image"
}

// MARK: - Extensions
extension TravelDocumentDetails {
    static func sample() -> TravelDocumentDetails {
        return TravelDocumentDetails(
            title: "United States Green Card",
            description: "Please double-check your details are correct and enter your country of permanent residence",
            id: "74662b79-211b-45ca-b60c-c9ba58429327",
            moderationErrors: ["Photo in the VISA does not match with Security Photo"],
            fields: [
                Field(
                    id: UUID().uuidString,
                    label: "Photo Url",
                    name: "documentPhotoUrl",
                    type: .image,
                    value: "https://cert.gcpshore.virginvoyages.com/dxpcore/mediaitems/3136d10c-aa5c-48e7-9fda-7474fb67299a",
                    readonly: true,
                    hidden: false,
                    required: false,
                    isSecure: false,
                    referenceName: "photoUrl"
                ),
                Field(
                    id: UUID().uuidString,
                    label: "Back photo",
                    name: "documentBackPhotoUrl",
                    type: .image,
                    value: "",
                    readonly: false,
                    hidden: false,
                    required: true,
                    isSecure: false,
                    referenceName: "documentBackPhotoUrl"
                ),
                Field(
                    id: UUID().uuidString,
                    label: "Given name",
                    name: "givenName",
                    type: .string,
                    value: "",
                    readonly: false,
                    hidden: false,
                    required: true,
                    isSecure: false,
                    referenceName: "givenName"
                ),
                Field(
                    id: UUID().uuidString,
                    label: "Green card number",
                    name: "greenCardNumber",
                    type: .number,
                    value: "test test",
                    readonly: false,
                    hidden: true,
                    required: true,
                    isSecure: true,
                    referenceName: "greenCardNumber"
                ),
                Field(
                    id: UUID().uuidString,
                    label: "Country of issue",
                    name: "country",
                    type: .dropdown,
                    value: "",
                    readonly: true,
                    hidden: true,
                    required: true,
                    isSecure: false,
                    referenceName: "country"
                ),
                Field(
                    id: UUID().uuidString,
                    label: "Date of issue",
                    name: "dateOfIssue",
                    type: .date,
                    value: "",
                    readonly: false,
                    hidden: false,
                    required: true,
                    isSecure: false,
                    referenceName: "dateOfIssue"
                )
            ],
            isScanable: false,
            isCapturable: false,
            isTwiceSide: false,
            scanFormatType: .passportOrVisa,
            isAlreadyUploaded: false,
            documentExpirationWarnConfig: DocumentExpirationWarnConfig(documentExpirationInMonths: 6, title: "Warning: Expired Passport", description: "<p>Your passport may be expired</p>"),
            documentCombinedRules: [
                       DocumentCombinedRule(
                           sourceDocumentType: "DL",
                           destinationDocumentType: "BC",
                           field: "number",
                           saveType: "Auto Save"
                       )
                   ]
        )
    }

    static func empty() -> TravelDocumentDetails {
        return TravelDocumentDetails(
            title: "",
            description: "",
            id: "",
            moderationErrors: [],
            fields: [],
            isScanable: false,
            isCapturable: false,
            isTwiceSide: false,
            scanFormatType: .nonScanabled,
            isAlreadyUploaded: false,
            documentExpirationWarnConfig: nil,
            documentCombinedRules: []
        )
    }
}
