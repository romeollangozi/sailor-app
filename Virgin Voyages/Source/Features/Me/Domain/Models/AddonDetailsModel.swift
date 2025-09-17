//
//  AddonDetailsModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.10.24.
//

import Foundation

struct AddonDetailsModel: Decodable, Equatable {
    
    // AddOnModel properties
    var imageURL: String = ""
    var name: String = ""
    var subtitle: String = ""
    var needToKnows: [String] = []
    var code: String = ""
    var currencyCode: String = ""
    var bonusDescription: String = ""
    var addonCategory: String = ""
    var longDescription: String = ""
    var isCancellable: Bool = false
    var isBookingEnabled: Bool = false
    var isPurchased: Bool = false
    var guests: [String] = []
    var isActionButtonsDisplay: Bool = false
    var eligibleGuestIds: [String] = []
    var amount: Double = 0.0
    var bonusAmount: Double = 0.0
    
    // AddonCMSModel properties
    var addonsHeaderText: String = ""
    var closedWindowText: String = ""
    var closedWindowExplainer: String = ""
    var addonsText: String = ""
    var purchasedForText: String = ""
    var wholeGroupText: String = ""
    var viewAddonPageText: String = ""
    var needToKnowsText: String = ""
    var cancelModalImageURL: String = ""
    var purchaseText: String = ""
    var cancelPurchaseText: String = ""
    var purchasedText: String = ""
    var cancelButtonText: String = ""
    var cancelClarifyText: String = ""
    var confirmationSubTitle: String = ""
    var confirmationHeading: String = ""
    var confirmationYesCancelText: String = ""
    var confirmationTitle: String = ""
    var confirmationChangedMindText: String = ""
    var viewAddonText: String = ""
    var cancelRefusedText: String = ""
    var purchaseCancelledText: String = ""
    var justForMeText: String = ""
    var contactSailorServiceText: String = ""
    var okButtonText: String = ""
    var baggedItText: String = ""
    var doneText: String = ""
    var viewAddonsText: String = ""
    
    // Additional fields
    var guestURL: [String] = []
    var guestId = try? AuthenticationService.shared.currentSailor().reservation.guestId

    // Constructor accepting specific properties
    init(addon: AddOnModel = AddOnModel(), cms: AddonCMSModel = AddonCMSModel(), guestURL: [String] = []) {
        //Addon
        self.imageURL = addon.imageURL
        self.name = addon.name
        self.subtitle = addon.subtitle
        self.needToKnows = addon.needToKnows
        self.code = addon.code
        self.currencyCode = addon.currencyCode
        self.bonusDescription = addon.bonusDescription
        self.addonCategory = addon.addonCategory
        self.longDescription = addon.longDescription
        self.isCancellable = addon.isCancellable
        self.isBookingEnabled = addon.isBookingEnabled
        self.isPurchased = addon.isPurchased
        self.guests = addon.guests
        self.isActionButtonsDisplay = addon.isActionButtonsDisplay
        self.eligibleGuestIds = addon.eligibleGuestIds
        self.amount = addon.amount
        self.bonusAmount = addon.bonusAmount
        
        //CMS
        self.addonsHeaderText = cms.addonsHeaderText
        self.closedWindowText = cms.closedWindowText
        self.closedWindowExplainer = cms.closedWindowExplainer
        self.addonsText = cms.addonsText
        self.purchasedForText = cms.purchasedForText
        self.wholeGroupText = cms.wholeGroupText
        self.viewAddonPageText = cms.viewAddonPageText
        self.needToKnowsText = cms.needToKnowsText
        self.cancelModalImageURL = cms.cancelModalImageURL
        self.purchaseText = cms.purchaseText
        self.cancelPurchaseText = cms.cancelPurchaseText
        self.purchasedText = cms.purchasedText
        self.cancelButtonText = cms.cancelButtonText
        self.cancelClarifyText = cms.cancelClarifyText
        self.confirmationSubTitle = cms.confirmationSubTitle
        self.confirmationHeading = cms.confirmationHeading
        self.confirmationYesCancelText = cms.confirmationYesCancelText
        self.confirmationTitle = cms.confirmationTitle
        self.confirmationChangedMindText = cms.confirmationChangedMindText
        self.viewAddonText = cms.viewAddonText
        self.cancelRefusedText = cms.cancelRefuesdText
        self.purchaseCancelledText = cms.purchaseCancelledText
        self.justForMeText = cms.justForMeText
        self.contactSailorServiceText = cms.contactSailorServiceText
        self.okButtonText = cms.okButtonText
        self.baggedItText = cms.baggedItText
        self.doneText = cms.doneText
        self.viewAddonsText = cms.viewAddonsText
        
        //Guest activity
        self.guestURL = guestURL

    }
    
    static func previewData() -> AddonDetailsModel {
        // Dummy data for AddOnModel
        let dummyAddon = AddOnModel(
            imageURL: "https://cert.gcpshore.virginvoyages.com/dam/jcr:b2c68d64-6e51-4854-a9c4-c7a4229ab396/IMG-FNB-Onboard-Welcome-Cocktail-1200x800.jpg",
            name: "Sample Addon",
            subtitle: "This is a sample subtitle for the addon",
            needToKnows: ["Bring a towel", "Check-in 15 minutes early"],
            code: "SAMPLE_CODE",
            currencyCode: "USD",
            bonusDescription: "Includes free drinks",
            addonCategory: "Entertainment",
            longDescription: "This is a detailed description of the addon.",
            isCancellable: true,
            guests: ["Guest 1", "Guest 2"],
            isActionButtonsDisplay: true,
            eligibleGuestIds: ["12345", "67890"],
            amount: 100.0,
            bonusAmount: 10.0
        )

        // Dummy data for AddonCMSModel
        let dummyCMS = AddonCMSModel(
            addonsHeaderText: "Available Add-ons",
            closedWindowText: "This window is closed",
            closedWindowExplainer: "Explanation about the closed window",
            addonsText: "Explore the various add-ons available",
            purchasedForText: "Purchased for you",
            wholeGroupText: "For the whole group",
            viewAddonPageText: "View details",
            needToKnowsText: "Important things to know",
            cancelModalImageURL: "",
            purchaseText: "Purchase this addon",
            cancelPurchaseText: "Cancel purchase",
            purchasedText: "You've already purchased this",
            cancelButtonText: "Cancel",
            cancelClarifyText: "Are you sure you want to cancel?",
            confirmationSubTitle: "Sub-title for confirmation",
            confirmationHeading: "Refund Amount",
            confirmationYesCancelText: "Yes, Cancel",
            confirmationTitle: "Confirmation",
            confirmationChangedMindText: "Changed your mind?",
            viewAddonText: "View add-ons",
            cancelRefuesdText: "You cannot cancel now",
            purchaseCancelledText: "Your purchase has been cancelled",
            justForMeText: "Just for me",
            contactSailorServiceText: "Contact Sailor Services",
            okButtonText: "OK",
            baggedItText: "You bagged it",
            doneText: "Done",
            viewAddonsText: "View all add-ons"
        )
        
        // Dummy guest URLs
        let dummyGuestURLs = ["https://cert.gcpshore.virginvoyages.com/dxpcore/mediaitems/91e388a5-5263-4cec-be10-1fdf08ad59dc", "https://cert.gcpshore.virginvoyages.com/dxpcore/mediaitems/91e388a5-5263-4cec-be10-1fdf08ad59dc"]

        // Create an instance of AddonDetailsModel using dummy data
        return AddonDetailsModel(addon: dummyAddon, cms: dummyCMS, guestURL: dummyGuestURLs)
    }
}
