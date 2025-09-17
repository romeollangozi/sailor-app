//
//  ScanTravelDocumentInputModel+Mapping.swift
//  Virgin Voyages
//
//  Created by Pajtim on 25.3.25.
//

import Foundation

extension ScanTravelDocumentInputModel {
    func toDomain(reservationGuestId: String) -> ScanTravelDocumentInput {
        return ScanTravelDocumentInput(
            documentCode: self.documentCode,
            categoryCode: self.categoryCode,
            documentType: self.documentType,
            ocrValidation: self.ocrValidation,
            reservationGuestId: reservationGuestId,
            photoContent: self.photoContent,
            documentPhotoId: self.documentPhotoId,
            documentBackPhotoId: self.documentBackPhotoId,
            id: self.id
        )
    }
}
