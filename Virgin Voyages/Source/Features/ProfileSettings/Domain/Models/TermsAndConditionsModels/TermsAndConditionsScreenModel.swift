//
//  TermsAndConditionsScreenModel.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 31.10.24.
//

import Foundation

struct TermsAndConditionsScreenModel {
    
    var title: String
    var menuItems: [TermsAndConditionsListItemModel]
    
    mutating func updateMenuItems(_ menuItems: [TermsAndConditionsListItemModel]) {
        self.menuItems = menuItems
    }
    
    init(title: String, menuItems: [TermsAndConditionsListItemModel]){
        self.title = title
        self.menuItems = menuItems
    }
    
    // Empty State Init
    init() {
        self.title = ""
        self.menuItems = []
    }
}

extension TermsAndConditionsScreenModel {
    static func map(from response: GetTermsAndConditionsScreenResponse) -> TermsAndConditionsScreenModel {
        let title = response.heading.value
        var items: [TermsAndConditionsListItemModel] = []
        
        // Map each response item if it exists
        if let generalItem = TermsAndConditionsScreenModel.mapTermsAndConditionsListItemResponse(response.general, key: .general) {
            items.append(generalItem)
        }
        if let mobileItem = TermsAndConditionsScreenModel.mapTermsAndConditionsListItemResponse(response.mobile, key: .mobile) {
            items.append(mobileItem)
        }
        if let privacyItem = TermsAndConditionsScreenModel.mapTermsAndConditionsListItemResponse(response.privacy, key: .privacy) {
            items.append(privacyItem)
        }
        if let cookieItem = TermsAndConditionsScreenModel.mapTermsAndConditionsListItemResponse(response.cookie, key: .cookie) {
            items.append(cookieItem)
        }
        
        return .init(title: title, menuItems: items)
    }
}

// Helper function to map GetTermsAndConditionsDetailsResponse to TermsAndConditionsListItemModel
extension TermsAndConditionsScreenModel  {
    static func mapTermsAndConditionsListItemResponse(
        _ details: GetTermsAndConditionsScreenResponse.GetTermsAndConditionsDetailsResponse?,
        key: TermsAndConditionListItemIdentifierKey
    ) -> TermsAndConditionsListItemModel? {
        guard let details = details else { return nil }
        
        let contentModels = details.content.map {
            print("\n$0.body : \(String(describing: $0.body)) \n")
            return TermsAndConditionsListItemModel.ContentModel(
                title: $0.title,
                subtitle: $0.subtitle,
                body: $0.body.value
            )
        }
        
        return TermsAndConditionsListItemModel(
            id: UUID().uuidString,
            key: key,
            heading: details.heading.value,
            content: contentModels
        )
    }
}
