//
//  DeleteTravelDocumentDetails+Mapping.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 21.3.25.
//

import Foundation

extension TravelDocumentDetails {
    func toInputModel(isVisa: Bool) -> DeleteDocumentInput {
        func value(for name: String) -> String {
            fields.first(where: { $0.name == name })?.value ?? ""
        }

        var details: [String: String] = Dictionary(
                   uniqueKeysWithValues: fields.map { ($0.name, $0.value) }
               )

        return DeleteDocumentInput(
            title: self.title,
            countryOfResidenceCode: value(for: "countryOfResidenceCode"),
            identificationDocuments: !isVisa ? details : nil,
            visaInfoList: isVisa ? details : nil
        )
    }
}
