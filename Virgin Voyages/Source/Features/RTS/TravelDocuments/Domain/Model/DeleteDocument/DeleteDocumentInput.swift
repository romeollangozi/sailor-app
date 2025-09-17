//
//  DeleteDocumentInput.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 21.3.25.
//

import Foundation

struct DeleteDocumentInput: Equatable, Hashable {
    var title: String
    var countryOfResidenceCode: String
    var identificationDocuments: [String:String]?
    var visaInfoList: [String:String]?

}

extension DeleteDocumentInput {
    static func sample() -> DeleteDocumentInput {
        return DeleteDocumentInput(
            title: "",
            countryOfResidenceCode: "",
            identificationDocuments: [:],
            visaInfoList: [:]
        )
    }
}
