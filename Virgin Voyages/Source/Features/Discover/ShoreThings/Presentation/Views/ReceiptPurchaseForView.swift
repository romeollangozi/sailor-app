//
//  ReceiptPurchaseForView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.11.24.
//

import SwiftUI
import VVUIKit

protocol ReceiptPurchaseForViewModelProtocol {
	var purchaseForText: String { get }
	var guests: [ReceiptPurchaseForViewGuest] { get }
}

struct ReceiptPurchaseForViewGuest: Identifiable {
	var id: String
	var imageURL: String
}

struct ReceiptPurchaseForView: View {
    let viewModel: ReceiptPurchaseForViewModelProtocol

    var body: some View {
        VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
            Text(viewModel.purchaseForText)
                .fontStyle(.boldTagline)
                .foregroundStyle(Color.slateGray)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Paddings.defaultPadding8) {
                    ForEach(viewModel.guests) { guest in
                        AuthURLImageView(imageUrl: guest.imageURL,size: Spacing.space48, clipShape: .circle, defaultImage: "ProfilePlaceholder")
                    }
                }
            }
        }
        .padding(Paddings.defaultVerticalPadding)
    }
}

struct ReceiptPurchaseForView_Previews: PreviewProvider {
	struct MockViewModel: ReceiptPurchaseForViewModelProtocol {
		let purchaseForText: String = "Purchased For"
		let guests: [ReceiptPurchaseForViewGuest] = [
			ReceiptPurchaseForViewGuest(id: "1", imageURL: ""),
			ReceiptPurchaseForViewGuest(id: "2", imageURL: ""),
			ReceiptPurchaseForViewGuest(id: "3", imageURL: "")
		]
	}

	static var previews: some View {
		ReceiptPurchaseForView(viewModel: MockViewModel())
			.previewLayout(.sizeThatFits)
			.padding()
	}
}
