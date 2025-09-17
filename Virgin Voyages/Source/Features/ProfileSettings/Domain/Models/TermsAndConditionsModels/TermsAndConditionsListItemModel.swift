//
//  TermsAndConditionsListItemModel.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 31.10.24.
//

import Foundation

struct TermsAndConditionsListItemModel: Identifiable {
    let id: String
    let keyIdentifier: TermsAndConditionListItemIdentifierKey
    let heading: String
    let content: [TermsAndConditionsListItemModel.ContentModel]
    
    init(id: String, key: TermsAndConditionListItemIdentifierKey, heading: String, content: [TermsAndConditionsListItemModel.ContentModel]) {
        self.id = id
        self.keyIdentifier = key
        self.heading = heading
        self.content = content
    }
    
    init() {
        id = UUID().uuidString
        keyIdentifier = .undefiend
        heading = ""
        content = []
    }
    
    struct ContentModel: Identifiable {
        var id: String
        let title: String?
        let subtitle: String?
        let body: String
        
        init(title: String?, subtitle: String?, body: String) {
            self.id = UUID().uuidString
            self.title = title
            self.subtitle = subtitle
            self.body = body
        }
    }
}

enum TermsAndConditionListItemIdentifierKey: String {
    case general = "general"
    case mobile = "mobile"
    case privacy = "privacy"
    case cookie = "cookie"
    case undefiend = ""
}

extension TermsAndConditionsListItemModel: Hashable {
    static func == (lhs: TermsAndConditionsListItemModel, rhs: TermsAndConditionsListItemModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
