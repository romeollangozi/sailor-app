//
//  ScanTravelDocumentInput+Mapping.swift
//  Virgin Voyages
//
//  Created by Pajtim on 24.3.25.
//

import Foundation

extension ScanTravelDocumentInput {
    func toNetworkDTO() -> TravelDocumentBody {
        return TravelDocumentBody(
            photoContent: self.photoContent,
            documentPhotoId: self.documentPhotoId,
            documentBackPhotoId: self.documentBackPhotoId,
            documentCode: self.documentCode,
            categoryCode: self.categoryCode,
            documentType: self.documentType
        )
    }
}
