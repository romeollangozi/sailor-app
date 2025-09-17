//
//  GetAddonDetailsResponse+Model.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 29.9.24.
//

import Foundation

extension Endpoint.GetAddonDetails.Response {
	// MARK: - GetAddonDetails.Response to AddOnDetails model
	func toModel() -> AddOnDetails {
		let addons = addOns.map({
			$0.toModel(
				purchasedText: cmsContent.purchasedText,
				soldOutText: cmsContent.soldOut.title,
				closedText: cmsContent.closedWindow.text,
				explainer: cmsContent.closedWindow.explainer
			)
		})
			.sorted { (first, second) -> Bool in
				if first.isSoldOut != second.isSoldOut {
					// Soldout addons should be at the bottom
					return !first.isSoldOut && second.isSoldOut
				} else if first.isPurchased != second.isPurchased {
					// Non-purchased addons come before purchased
					return !first.isPurchased && second.isPurchased
				} else {
					// If both are in the same category, compare by name
					let firstName = first.name.value
					let secondName = second.name.value
					return firstName.localizedCompare(secondName) == .orderedAscending
				}
			}
		let cms = cmsContent
		return AddOnDetails(cms: cms, addOns: addons)
	}
}

extension AddOnDTO {
	// MARK: - AddOnDTO to AddOn model
	func toModel(purchasedText: String, soldOutText: String, closedText: String, explainer: String) -> AddOn {
		return AddOn(
			shortDescription: shortDescription,
			name: name,
			subtitle: subtitle,
			amount: amount,
			bonusAmount: bonusAmount,
			addonCategory: addonCategory,
			code: code,
			bonusDescription: bonusDescription,
			longDescription: longDescription,
			imageURL: landscapeTitleImage.src ?? "",
			detailReceiptDescription: detailReceiptDescription,
			currencyCode: currencyCode,
			isCancellable: isCancellable,
			isPurchased: isPurchased,
			sellType: AddOnSellType(rawValue: sellType ?? "") ?? .perSailor,
			isPerSailorPurchase: isPerSailorPurchase,
			isBookingEnabled: isBookingEnabled,
			isActionButtonsDisplay: isActionButtonsDisplay,
			isSoldOut: isSoldOut,
			isSoldOutText: soldOutText,
			isPurchasedText: purchasedText,
			closedText: closedText,
			needToKnows: needToKnows ?? [],
			explainer: explainer,
			eligibleGuestIds: eligibleGuestIds?.compactMap({ $0 }) ?? [],
			guests: guests ?? [],
			totalAmount: totalAmount ?? 0.0,
			guestRefNumbers: guestRefNumbers ?? [])
	}
}
