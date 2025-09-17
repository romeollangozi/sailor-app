//
//  TravelDocuments.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 18.2.25.
//

import Foundation

struct TravelDocuments: Equatable, Hashable {
    let title: String
    let description: String
    let citizenship: String
    var citizenshipType: CitizenshipType
    let actionText: String
    var hasPostVoyagePlans: Bool
    let debarkCountryName: String
    let governmentLink: String
    var documentStages: [DocumentStage]

    struct DocumentStage: Equatable, Hashable {
        let title: String
        let description: String
        var isChoisable: Bool?
        var isCompleted: Bool?
        var documents: [Document]

        static func empty() -> DocumentStage {
            return DocumentStage(
                title: "",
                description: "",
                isChoisable: nil,
                isCompleted: nil,
                documents: []
            )
        }
    }
    
    struct CategoryDetails: Equatable, Hashable {
        let title: String
        let description: String
        let categories: [Document]?

        static func empty() -> CategoryDetails {
            return CategoryDetails(
                title: "",
                description: "",
                categories: nil
            )
        }
    }

    struct Document: Equatable, Identifiable, Hashable {
        let id: UUID = UUID()
        let name: String
        let type: String
        let code: String
        let categoryCode: String?
        let categoryId: String?
        var isScanable: Bool
        var isCapturable: Bool
        var isTwiceSide: Bool
        let isAlreadyUploaded: Bool
        let scanFormatType: ScanFormatType
        let documentId: String
        let mrzField: MrzField
        let isMultiCategoryDocument: Bool?
        let categoryDetails: CategoryDetails?

        static func empty() -> Document {
            return Document(
                name: "",
                type: "",
                code: "",
                categoryCode: nil,
                categoryId: nil,
                isScanable: false,
                isCapturable: false,
                isTwiceSide: false,
                isAlreadyUploaded: false,
                scanFormatType: .passportOrVisa,
                documentId: "",
                mrzField: .front,
                isMultiCategoryDocument: nil,
                categoryDetails: nil
            )
        }
        
        static func sample(
                name: String = "Test",
                type: String = "",
                code: String = "",
                categoryCode: String? = nil,
                categoryId: String? = nil,
                isScanable: Bool = false,
                isCapturable: Bool = false,
                isTwiceSide: Bool = false,
                isAlreadyUploaded: Bool = false,
                scanFormatType: ScanFormatType = .cardFormatTwoSides,
                documentId: String = "",
                mrzField: MrzField = .front
            ) -> Document {
                
                return Document(
                    name: name,
                    type: type,
                    code: code,
                    categoryCode: categoryCode,
                    categoryId: categoryId,
                    isScanable: isScanable,
                    isCapturable: isCapturable,
                    isTwiceSide: isTwiceSide,
                    isAlreadyUploaded: isAlreadyUploaded,
                    scanFormatType: scanFormatType,
                    documentId: documentId,
                    mrzField: mrzField,
                    isMultiCategoryDocument: nil,
                    categoryDetails: nil
                )
            }
    }
}

// MARK: - Enums
enum CitizenshipType: String, Equatable {
    case known = "Known"
    case rulesAreNotDefined = "RulesAreNotDefined"
    case unknown = "Unknown"
}

enum ScanFormatType: String, Equatable {
    case passportOrVisa = "PassportOrVisa"
    case cardFormatMrz = "CardFormatMrz"
    case cardFormatTwoSides = "CardFormatTwoSides"
    case nonScanabled = "NonScanabled"
    case capturable = "Capturable"
}

enum MrzField: String, Equatable {
   case none = "None"
   case front = "Front"
   case back = "Back"
}

// MARK: - Extensions
extension TravelDocuments {
    static func sample(debarkCountryName: String = "", governmentLink: String = "") -> TravelDocuments {
        return TravelDocuments(
            title: "Travel documents",
            description: "You told us your citizenship is US. Based on that, we need to collect certain documents from you to facilitate smoother immigration processing at all our ports.",
            citizenship: "US",
            citizenshipType: .known,
            actionText: "Get started",
            hasPostVoyagePlans: false,
            debarkCountryName: debarkCountryName,
            governmentLink: governmentLink,
            documentStages: [
                DocumentStage(
                    title: "Passport Scan",
                    description: "It looks like there are multiple options for your primary document.",
                    isChoisable: true,
                    isCompleted: false,
                    documents: [
                        Document(
                            name: "Passport",
                            type: "passport",
                            code: "P",
                            categoryCode: "P",
                            categoryId: "1",
                            isScanable: true,
                            isCapturable: false,
                            isTwiceSide: false,
                            isAlreadyUploaded: false,
                            scanFormatType: .passportOrVisa,
                            documentId: "",
                            mrzField: .front,
                            isMultiCategoryDocument: nil,
                            categoryDetails: nil
                        )
                    ]
                ),
                DocumentStage(
                    title: "Choose your Secondary document",
                    description: "Looks like there are some options for your secondary document",
                    isChoisable: true,
                    isCompleted: false,
                    documents: [
                        Document(
                            name: "Visa",
                            type: "visa",
                            code: "V",
                            categoryCode: "RV",
                            categoryId: "1",
                            isScanable: false,
                            isCapturable: false,
                            isTwiceSide: false,
                            isAlreadyUploaded: false,
                            scanFormatType: .passportOrVisa,
                            documentId: "",
                            mrzField: .front,
                            isMultiCategoryDocument: nil,
                            categoryDetails: nil
                        ),
                        Document(
                            name: "E-Visa",
                            type: "visa",
                            code: "V",
                            categoryCode: "EV",
                            categoryId: "2",
                            isScanable: false,
                            isCapturable: false,
                            isTwiceSide: false,
                            isAlreadyUploaded: false,
                            scanFormatType: .passportOrVisa,
                            documentId: "",
                            mrzField: .none,
                            isMultiCategoryDocument: nil,
                            categoryDetails: nil
                        )
                    ]
                )
            ]
        )
    }
    
    static func empty() -> TravelDocuments {
        return TravelDocuments(
            title: "",
            description: "",
            citizenship: "",
            citizenshipType: .unknown,
            actionText: "",
            hasPostVoyagePlans: false,
            debarkCountryName: "",
            governmentLink: "",
            documentStages: []
        )
    }
}

