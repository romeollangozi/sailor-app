//
//  GetTravelDocumentsRequest+Mapping.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 18.2.25.
//

import Foundation

extension GetTravelDocumentsResponse {
    func toDomain() -> TravelDocuments {
        return TravelDocuments(
            title: self.title.value,
            description: self.description.value,
            citizenship: self.citizenship.value,
            citizenshipType: CitizenshipType(rawValue: self.citizenshipType.value) ?? .unknown,
            actionText: self.actionText.value,
            hasPostVoyagePlans: self.hasPostVoyagePlans.value,
            debarkCountryName: self.debarkCountryName.value,
            governmentLink: self.govermentLink.value,
            documentStages: self.documentStages?.map { stage in
                TravelDocuments.DocumentStage(
                    title: stage.title.value,
                    description: stage.description.value,
                    isChoisable: stage.isChoisable.value,
                    isCompleted: stage.isCompleted.value,
                    documents: stage.documents?.map { doc in
                        TravelDocuments.Document(
                            name: doc.name.value,
                            type: doc.type.value,
                            code: doc.code.value,
                            categoryCode: doc.categoryCode.value,
                            categoryId: doc.categoryId.value,
                            isScanable: doc.isScanable.value,
                            isCapturable: doc.isCapturable.value,
                            isTwiceSide: doc.isTwiceSide.value,
                            isAlreadyUploaded: doc.isAlreadyUploaded.value,
                            scanFormatType: ScanFormatType(rawValue: doc.scanFormatType.value) ?? .passportOrVisa,
                            documentId: doc.documentId.value,
                            mrzField: MrzField(rawValue: doc.mrzField.value) ?? .none,
                            isMultiCategoryDocument: doc.isMultiCategoryDocument,
                            categoryDetails: doc.categoryDetails.map { category in
                                TravelDocuments.CategoryDetails(
                                    title: category.title.value,
                                    description: category.description.value,
                                    categories: category.categories?.map { nestedDoc in
                                        TravelDocuments.Document(
                                            name: nestedDoc.name.value,
                                            type: nestedDoc.type.value,
                                            code: nestedDoc.code.value,
                                            categoryCode: nestedDoc.categoryCode.value,
                                            categoryId: nestedDoc.categoryId.value,
                                            isScanable: nestedDoc.isScanable.value,
                                            isCapturable: nestedDoc.isCapturable.value,
                                            isTwiceSide: nestedDoc.isTwiceSide.value,
                                            isAlreadyUploaded: nestedDoc.isAlreadyUploaded.value,
                                            scanFormatType: ScanFormatType(rawValue: nestedDoc.scanFormatType.value) ?? .passportOrVisa,
                                            documentId: nestedDoc.documentId.value,
                                            mrzField: MrzField(rawValue: nestedDoc.mrzField.value) ?? .none,
                                            isMultiCategoryDocument: nestedDoc.isMultiCategoryDocument,
                                            categoryDetails: nil
                                        )
                                    }
                                )
                            }
                        )
                    } ?? []
                )
            } ?? []
        )
    }
}
