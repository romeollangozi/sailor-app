//
//  AddonDetilsDTO.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 29.9.24.
//

import Foundation


// MARK: - AddOn
struct AddOnDetailsResponse: Decodable {
    var shortDescription, name, subtitle: String?
    var amount, bonusAmount: Double?
    var addonCategory: String?
    var needToKnows: [String]? = []
    var code, bonusDescription, longDescription: String?
    var landscapeTitleImage: LandscapeTitleImageResponse?
    var detailReceiptDescription, currencyCode: String?
    var isCancellable, isPurchased, isBookingEnabled: Bool?
    var guests: [String]?
    var eligibleGuestIds: [String]?
    var isActionButtonsDisplay, isSoldOut: Bool?
    
    static func mapFrom(input: AddOnDetailsResponse) -> AddOn {
        return AddOn(shortDescription: input.shortDescription.value,
                     name: input.name.value,
                     subtitle: input.subtitle.value,
                     amount: input.amount.value,
                     bonusAmount: input.bonusAmount.value,
                     addonCategory: input.addonCategory.value,
                     code: input.code.value,
                     bonusDescription: input.bonusDescription.value,
                     longDescription: input.longDescription.value,
                     imageURL: input.landscapeTitleImage?.src.value ?? "",
                     detailReceiptDescription: input.detailReceiptDescription.value,
                     currencyCode: input.currencyCode.value,
                     isCancellable: input.isCancellable.value,
                     isPurchased: input.isPurchased.value,
                     isBookingEnabled: input.isBookingEnabled.value,
                     isActionButtonsDisplay: input.isActionButtonsDisplay.value,
                     isSoldOut: input.isSoldOut.value,
                     needToKnows: input.needToKnows ?? [], 
                     eligibleGuestIds: input.eligibleGuestIds ?? [],
                     guests: input.guests ?? [])
    }
}

// MARK: - LandscapeTitleImage
struct LandscapeTitleImageResponse: Decodable {
    let src: String?
    let alt: String?
}
