//
//  PaymentSummaryCardDetailsView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/17/24.
//

import SwiftUI
import VVUIKit

struct PaymentSummaryCardDetailsView: View {
	let cardIssuer: String
	let maskedCardNumber: String
	let cardImage: UIImage?

	var body: some View {
		VStack(spacing: 24.0) {
			Text("Payment method")
				.fontStyle(.largeTagline)
				.foregroundColor(.blackText)
				.bold()
			HStack(spacing: 16) {
				if let cardImage = cardImage {
					Image(uiImageWithData: cardImage)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 60, height: 40)
				}
				VStack(alignment: .leading, spacing: 0) {
					Text(cardIssuer)
						.fontStyle(.smallBody)
						.foregroundColor(.slateGray)
						.bold()
					Text(maskedCardNumber)
						.fontStyle(.smallBody)
						.foregroundColor(.slateGray)
				}
			}
		}
	}
}
