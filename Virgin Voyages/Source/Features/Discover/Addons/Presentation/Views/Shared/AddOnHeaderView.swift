//
//  AddOnHeaderView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 1.10.24.
//

import SwiftUI
import VVUIKit

struct AddOnHeaderView: View {
    
    // MARK: - Addon
	var viewModel: AddOnHeaderViewModelProtocol
    var imageHeight: Double
	
	let onViewReceiptClick: ((String) -> Void)?
    
    // MARK: - Init
	init(viewModel: AddOnHeaderViewModelProtocol, imageHeight: Double = 240.0, onViewReceiptClick: ((String) -> Void)? = nil) {
        self.viewModel = viewModel
        self.imageHeight = imageHeight
		self.onViewReceiptClick = onViewReceiptClick
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
				if let imageURL = viewModel.imageURL {
					FlexibleProgressImage(url: URL(string: imageURL))
						.frame(height: imageHeight)
						.frame(maxWidth: .infinity)
						.cornerRadius(CornerRadiusValues.defaultCornerRadius, corners: [.topLeft, .topRight])
						.grayscale(viewModel.imageGrayscalePercent)
				}
                HStack(spacing: Paddings.zero) {
                    if !(viewModel.addOn.addOnState == AddonState.soldOut) {
                        PriceView(price: viewModel.price.value, state: viewModel.priceViewStateType)
                        Spacer()
					}
					if let closedText = viewModel.closedText {
						UnavailableView(text: closedText,
										isClosed: viewModel.addOn.addOnState == .closed)
					}
					if let soldOutText = viewModel.soldOutText {
						UnavailableView(text: soldOutText,
										isClosed: viewModel.addOn.addOnState == .closed)
					}
                }
				.background(viewModel.priceLabelBackgroundColor)

            }
			if let isPurchasedText = viewModel.isPurchasedText {
				Button(action: {
					onViewReceiptClick?(viewModel.addOn.code.value)
				}) {
					PurchasedLabelView(text: isPurchasedText)
				}
			}
        }
        .frame(maxWidth: .infinity)
    }
}
