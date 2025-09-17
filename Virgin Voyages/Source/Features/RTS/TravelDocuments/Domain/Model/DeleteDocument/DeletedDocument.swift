//
//  DeletedDocument.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 21.3.25.
//

import Foundation

struct DeletedDocument: Equatable, Hashable {
    let tasksCompletionPercentage: TasksCompletionPercentage
    let fieldErrors: FieldErrors
    let enablePostCruiseTab: Bool

    struct TasksCompletionPercentage: Equatable, Hashable {
        let security: Int
        let travelDocuments: Int
        let paymentMethod: Int
        let pregnancy: Int
        let voyageContract: Int
        let emergencyContact: Int
        let embarkationSlotSelection: Int
    }

    struct FieldErrors: Equatable, Hashable {
        let fieldErrors: [String]
    }
}

extension DeletedDocument {
    static func sample() -> DeletedDocument {
        return DeletedDocument(
            tasksCompletionPercentage: .init(
                security: 0,
                travelDocuments: 0,
                paymentMethod: 0,
                pregnancy: 0,
                voyageContract: 0,
                emergencyContact: 0,
                embarkationSlotSelection: 0
            ),
            fieldErrors: .init(fieldErrors: []),
            enablePostCruiseTab: false
        )
    }
}
