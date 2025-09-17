//
//  GetMyDocumentsResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Pajtim on 14.3.25.
//

import Foundation

extension GetMyDocumentsResponse {
    func toDomain() -> MyDocuments {
        return MyDocuments(
            documents: self.documents?.map { document in
                MyDocuments.Document(
                    id: document.id.value,
                    name: document.name.value,
                    documentPhotoUrl: document.documentPhotoUrl.value,
                    documentCode: document.documentCode.value,
                    categoryCode: document.categoryCode.value,
                    documentType: document.documentType.value,
                    isSecure: document.isSecure.value,
                    moderationErrors: document.moderationErrors ?? []
                )
            } ?? [],
            hasPostVoyagePlans: self.hasPostVoyagePlans.value
        )
    }
}
