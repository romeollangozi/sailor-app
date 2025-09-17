//
//  FolioResources.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 1.7.25.
//

struct FolioResources {
    let cardOnFileText: String
    let cardExplainerText: String
    let barTabExplainerText: String
    let barTabInfoDrawerHeadline: String
    let barTabInfoDrawerBody: String
    let walletFolioTotalText: String
    let shipEatsTaxText: String
    let globalGlobalShortStringsSubtotal: String

    static func empty() -> FolioResources {
        FolioResources(
            cardOnFileText: "",
            cardExplainerText: "",
            barTabExplainerText: "",
            barTabInfoDrawerHeadline: "",
            barTabInfoDrawerBody: "",
            walletFolioTotalText: "",
            shipEatsTaxText: "",
            globalGlobalShortStringsSubtotal: ""
        )
    }
    
    static func sample() -> FolioResources {
        FolioResources(
            cardOnFileText: "Your card on file",
            cardExplainerText: "Payments and refunds explained",
            barTabExplainerText: "Bar Tab explained",
            barTabInfoDrawerHeadline: "Bar Tab",
            barTabInfoDrawerBody: "A Bar Tab is automatically used when you purchase alcoholic and nonalcoholic crafted beverages onboard the ship and at our Beach Club at Bimini",
            walletFolioTotalText: "TOTAL",
            shipEatsTaxText: "TAX",
            globalGlobalShortStringsSubtotal: "Subtotal"
        )
    }
}
