//
//  ScanTravelDocumentInputModel.swift
//  Virgin Voyages
//
//  Created by Pajtim on 25.3.25.
//

import Foundation

struct ScanTravelDocumentInputModel: Equatable, Hashable {
    let documentCode: String
    let categoryCode: String
    let documentType: String
    let ocrValidation: Bool
    let photoContent: String?
    let documentPhotoId: String?
    let documentBackPhotoId: String?
    let id: String?

    static func empty() -> ScanTravelDocumentInputModel {
        return ScanTravelDocumentInputModel(
            documentCode: "",
            categoryCode: "",
            documentType: "",
            ocrValidation: true,
            photoContent: nil,
            documentPhotoId: nil,
            documentBackPhotoId: nil,
            id: nil
        )
    }
}
