//
//  ScanTravelDocumentInput.swift
//  Virgin Voyages
//
//  Created by Pajtim on 24.3.25.
//

import Foundation

struct ScanTravelDocumentInput: Equatable, Hashable {
    let documentCode: String
    let categoryCode: String
    let documentType: String
    let ocrValidation: Bool
    let reservationGuestId: String
    let photoContent: String?
    let documentPhotoId: String?
    let documentBackPhotoId: String?
    let id: String?
}
