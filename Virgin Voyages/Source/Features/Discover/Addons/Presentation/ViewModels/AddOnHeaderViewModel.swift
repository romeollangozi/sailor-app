//
//  AddOnHeaderViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/10/24.
//

import SwiftUI

protocol AddOnHeaderViewModelProtocol {
    var imageURL: String? { get }
    var price: String? { get }
    var isPurchasedText: String? { get }
    var closedText: String? { get }
    var soldOutText: String? { get }
    var priceLabelBackgroundColor: Color { get }
    var priceViewStateType: PriceView.StateType { get }
    var imageGrayscalePercent: Double { get }
    var addOn: AddOn { get set }
}

@Observable class AddOnHeaderViewModel: AddOnHeaderViewModelProtocol {
    var addOn: AddOn

    init(addOn: AddOn) {
        self.addOn = addOn
    }

    var imageURL: String? {
        return addOn.imageURL
    }

    var price: String? {
        guard let base = addOn.price else { return nil }
        // If the add-on is sold per cabin, show price per sailor per ticket requirements
        if addOn.sellType == .perCabin {
            return "\(base) per Sailor"
        }
        return base
    }

    var isPurchasedText: String? {
        if addOn.isPurchased, let isPurchasedText = addOn.isPurchasedText {
            return isPurchasedText
        }
        return nil
    }

    var closedText: String? {
        if addOn.addOnState == .closed, let closedText = addOn.closedText {
            return closedText.uppercased()
        }
        return nil
    }

    var soldOutText: String? {
        if addOn.addOnState == .soldOut, let soldOutText = addOn.isSoldOutText {
            return soldOutText.uppercased()
        }
        return nil
    }

    var priceLabelBackgroundColor: Color {
        (addOn.addOnState == .closed || addOn.addOnState == .soldOut) ? .black : .clear
    }

    var priceViewStateType: PriceView.StateType {
        let state: PriceView.StateType = addOn.addOnState == .closed || addOn.addOnState == .soldOut ? .unavailable : .available
        return state
    }

    var imageGrayscalePercent: Double {
        return (addOn.addOnState == .closed || addOn.addOnState ==  .soldOut) ? 1.0 : 0.0
    }
}
