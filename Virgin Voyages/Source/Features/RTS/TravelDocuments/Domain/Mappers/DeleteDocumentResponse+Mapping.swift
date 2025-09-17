//
//  DeleteDocumentResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 21.3.25.
//

import Foundation

extension DeleteDocumentResponse {
    func toDomain() -> DeletedDocument {
        return DeletedDocument(
            tasksCompletionPercentage: {
                let t = self.tasksCompletionPercentage
                return DeletedDocument.TasksCompletionPercentage(
                    security: t?.security ?? 0,
                    travelDocuments: t?.travelDocuments ?? 0,
                    paymentMethod: t?.paymentMethod ?? 0,
                    pregnancy: t?.pregnancy ?? 0,
                    voyageContract: t?.voyageContract ?? 0,
                    emergencyContact: t?.emergencyContact ?? 0,
                    embarkationSlotSelection: t?.embarkationSlotSelection ?? 0
                )
            }(),
            fieldErrors: {
                let errors = self.fieldErrors?.fieldErrors ?? []
                return DeletedDocument.FieldErrors(fieldErrors: errors)
            }(),
            enablePostCruiseTab: self.enablePostCruiseTab ?? false
        )
    }
}
