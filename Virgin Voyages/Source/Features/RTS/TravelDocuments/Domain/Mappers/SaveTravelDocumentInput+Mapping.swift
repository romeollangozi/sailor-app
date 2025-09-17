//
//  SaveTravelDocumentInput+Mapping.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 9.7.25.
//

import Foundation

extension SaveTravelDocumentInput {
    func toNetworkDTO() -> SaveTravelDocumentBody {
        let mappedRules = self.documentCombinedRules.map {
            DocumentCombinedRule(
                sourceDocumentType: $0.sourceDocumentType,
                destinationDocumentType: $0.destinationDocumentType,
                field: $0.field,
                saveType: $0.saveType
            )
        }

        return SaveTravelDocumentBody(
            fields: self.fields,
            documentCombinedRules: mappedRules
        )
    }
}
