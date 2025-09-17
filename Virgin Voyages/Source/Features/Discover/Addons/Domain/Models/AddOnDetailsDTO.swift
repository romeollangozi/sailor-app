//
//  AddOnDetailsDTO.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 29.9.24.
//

import Foundation


// MARK: - AddOn
struct AddOnDTO: Decodable {
    var shortDescription, name, subtitle: String
    var amount, bonusAmount: Double?
    var addonCategory: String?
    var needToKnows: [String]? = []
    var code, bonusDescription, longDescription: String
    var landscapeTitleImage: LandscapeTitleImageDTO
    var detailReceiptDescription, currencyCode: String?
    var isCancellable, isPurchased, isBookingEnabled, isPerSailorPurchase: Bool
	var sellType: String?
    var guests: [String]?
    var eligibleGuestIds: [String?]?
    var isActionButtonsDisplay, isSoldOut: Bool
	var totalAmount: Double?
	var guestRefNumbers: [Int]?
}

// MARK: - LandscapeTitleImage
struct LandscapeTitleImageDTO: Decodable {
    let src: String?
    let alt: String?
}

// MARK: - CMSContent
struct CMSContentDTO: Decodable {
    let addonsHeaderText: String
    let closedWindow: ClosedWindowDTO
    let addonsText, purchasedForText, wholeGroupText, viewAddonPageText: String
    let needToKnowsText: String?
    let cancelModalImageURL: String?
    let purchaseText, cancelPurchaseText, purchasedText, cancelButtonText: String
    let plusText: String?
    let circleIconURL: String?
    let cancelClarifyText: String?
    let confirmCancellation: ConfirmCancellationDTO?
    let viewAddonText: String?
    let soldOut: SoldOutDTO
    let cancelRefuesdText: String?
    let giftIconURL: String?
    let purchaseCancelledText, justForMeText, contactSailorServiceText, okButtonText: String?
    let baggedItText, doneText, viewAddonsText: String?
}

// MARK: - ClosedWindow
struct ClosedWindowDTO: Decodable {
    let text, explainer: String
}

// MARK: - ConfirmCancellation
struct ConfirmCancellationDTO: Decodable {
    let image: String?
    let subTitle, heading, yesCancelText, title: String?
    let changedMindText: String?
}

// MARK: - SoldOut
struct SoldOutDTO: Decodable {
    let title: String
}
