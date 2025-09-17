//
//  ScanTravelDocumentResponse+Mapping.swift
//
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 12.3.25.
//

import Foundation

extension ScanTravelDocumentResponse {
    func toDomain() -> TravelDocumentDetails {
        return TravelDocumentDetails(
            title: self.title.value,
            description: self.description.value,
            id: self.id.value,
            moderationErrors: self.moderationErrors ?? [],
            fields: self.fields?.map { field in
                TravelDocumentDetails.Field(
                    id: UUID().uuidString,
                    label: field.label.value,
                    name: field.name.value,
                    type: FieldType(rawValue: field.type.value) ?? .string,
                    value: field.value.value,
                    readonly: field.readonly.value,
                    hidden: field.hidden.value,
                    required: field.required.value,
                    isSecure: field.isSecure.value,
                    referenceName: field.referenceName.value,
                    maskedValue: field.maskedValue.value
                )
            } ?? [],
            isScanable: self.isScanable.value,
            isCapturable: self.isCapturable.value,
            isTwiceSide: self.isTwiceSide.value,
            scanFormatType: ScanType(rawValue: self.scanFormatType.value) ?? .nonScanabled,
            isAlreadyUploaded: self.isAlreadyUploaded.value,
            documentExpirationWarnConfig: self.documentExpirationWarnConfig.map {
                TravelDocumentDetails.DocumentExpirationWarnConfig(
                    documentExpirationInMonths: $0.documentExpirationInMonths,
                    title: $0.title,
                    description: $0.description
                )
            },
            documentCombinedRules: self.documentCombinedRules?.map {
                TravelDocumentDetails.DocumentCombinedRule(
                               sourceDocumentType: $0.sourceDocumentType,
                               destinationDocumentType: $0.destinationDocumentType,
                               field: $0.field,
                               saveType: $0.saveType
                           )
                       } ?? []
        )
    }
}
