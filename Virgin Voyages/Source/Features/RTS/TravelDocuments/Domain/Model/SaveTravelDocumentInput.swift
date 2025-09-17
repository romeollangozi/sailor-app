//
//  SaveTravelDocumentInput.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 18.3.25.
//

struct SaveTravelDocumentInput: Equatable, Hashable {
    var fields: [String: String]
    var documentExpirationWarnConfig: TravelDocumentDetails.DocumentExpirationWarnConfig?
    var documentCombinedRules: [TravelDocumentDetails.DocumentCombinedRule]
}
