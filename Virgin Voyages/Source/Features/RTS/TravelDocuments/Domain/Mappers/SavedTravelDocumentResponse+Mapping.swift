//
//  PostTravelDocumentResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 4.3.25.
//

import Foundation

extension SaveTravelDocResponse {
    func toDomain() -> SavedTravelDocument {
           return SavedTravelDocument(
            identificationId: self.identificationId ?? "",
            hasPostVoyagePlans: self.hasPostVoyagePlans ?? false
           )
       }
}
