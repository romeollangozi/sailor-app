//
//  AddonDetails.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 29.9.24.
//

import Foundation

// MARK: - AddOn details model
struct AddOnDetails {

    // MARK: - Properties
    let cms: CMSContentDTO?
    let addOns: [AddOn]

    // MARK: - Init
    init(cms: CMSContentDTO? = nil, addOns: [AddOn]) {
        self.cms = cms
        self.addOns = addOns
    }
    
    // MARK: - Computed properties
    var addOnsText: String {
        return cms?.addonsText ?? ""
    }

    var purchasedForText: String {
        return (cms?.purchasedForText ?? "").uppercased()
    }
    
    var needToKnowsText: String {
        return (cms?.needToKnowsText ?? "").uppercased()
    }
    
    var addOnsSubtitle: String {
        return cms?.addonsHeaderText ?? ""
    }
    
    var viewAddOnsText: String {
        return cms?.viewAddonText ?? ""
    }

    var cancelPurchaseText: String {
        return cms?.cancelPurchaseText ?? ""
    }
    
    var contactSailorServiceText: String {
        return cms?.contactSailorServiceText ?? ""
    }
    
    
    var viewAddonPageText: String {
        return cms?.viewAddonPageText ?? ""
    }
}

extension AddOnDetails {
    func getAddonDetails() -> AddOn {
        guard let addOn = self.addOns.first else { return AddOn() }
        return addOn
    }
}
