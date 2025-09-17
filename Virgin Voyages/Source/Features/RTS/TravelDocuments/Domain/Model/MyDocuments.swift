//
//  MyDocuments.swift
//  Virgin Voyages
//
//  Created by Pajtim on 14.3.25.
//

import Foundation

struct MyDocuments: Equatable, Hashable {
    let documents: [Document]
    let hasPostVoyagePlans: Bool

    struct Document: Equatable, Hashable {
        let id: String
        let name: String
        let documentPhotoUrl: String
        let documentCode: String
        let categoryCode: String
        let documentType: String
        let isSecure: Bool
        let moderationErrors: [String]

        static func empty() -> Document {
            return .init(
                id: "",
                name: "",
                documentPhotoUrl: "",
                documentCode: "",
                categoryCode: "",
                documentType: "",
                isSecure: false,
                moderationErrors: []
            )
        }

        static func sample() -> Document {
            Document(
                id: "f67c581d-4a9b-e611-80c2-00155df80332",
                name: "Passport",
                documentPhotoUrl: "https://example.com/wallet.jpg",
                documentCode: "P",
                categoryCode: "P",
                documentType: "passport",
                isSecure: false,
                moderationErrors: ["Photo in the VISA does not match with Security Photo"]
            )
        }
    }

}

extension MyDocuments {
    static func empty() -> MyDocuments {
        return .init(documents: [Document.empty()], hasPostVoyagePlans: false)
    }

    static func sample() -> MyDocuments {
        MyDocuments(
            documents: [Document.sample()],
            hasPostVoyagePlans: true
        )
    }
}


