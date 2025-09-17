//
//  DeleteDocumentInput+Mapping.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 21.3.25.
//

import Foundation

extension DeleteDocumentInput {
    func toNetworkDTO() -> DeleteTravelDocBody {
        var mappedIdentificationDocuments: [String: InputValue]? = nil
        if var idDocs: [String: InputValue] = self.identificationDocuments?.mapValues({ .string($0) }){
            idDocs["isDeleted"] = .bool(true)
            mappedIdentificationDocuments = idDocs
        }

        var mappedVisaInfoList: [String: InputValue]? = nil
        if var visaList: [String: InputValue] = self.visaInfoList?.mapValues({ .string($0) }) {
            visaList["isDeleted"] = .bool(true)
            mappedVisaInfoList = visaList
        }

        return DeleteTravelDocBody(
            travelDocumentsDetail: DeleteTravelDocumentsDetail(
                countryOfResidenceCode: self.countryOfResidenceCode,
                identificationDocuments: mappedIdentificationDocuments != nil ? [mappedIdentificationDocuments] : nil,
                visaInfoList: mappedVisaInfoList != nil ? [mappedVisaInfoList] : nil
            )
        )
    }
}
