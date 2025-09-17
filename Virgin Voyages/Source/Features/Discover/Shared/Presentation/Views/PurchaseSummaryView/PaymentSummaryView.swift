//
//  PaymentSummaryView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/17/24.
//

import SwiftUI
import VVUIKit

struct PaymentSummaryView: View {
	let description: String
	let price: String
	let paymentError: String?

	var body: some View {
		VStack(spacing: 0) {
			if let paymentError = paymentError {
				PaymentErrorView(paymentError: paymentError)
					.padding(.bottom, Spacing.space24)
			}
			HStack(spacing: 0) {
				Text("To Pay")
					.fontStyle(.largeTagline)
					.foregroundColor(.blackText)
					.bold()
				Spacer()
			}
			PaymentSummaryLineItemContentView(lineItemViews: [
				PaymentSummaryLineItemView(description: description, price: price)
			])
			SingleLineSeparator()
			TotalToPayLineItemView(price: price)
		}
		.padding(24.0)
	}
}

struct PaymentErrorView: View {
	let paymentError: String
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 12)
				.stroke(Color(hex: "#C25B28").opacity(0.5), lineWidth: 1)
				.background(Color(hex: "#FFFAF1"))
				.cornerRadius(12)

			HStack(alignment: .top, spacing: 12) {
				ZStack {
					Circle()
						.fill(Color(hex: "#C25B28"))
						.frame(width: 24, height: 24)

					Text("!")
						.font(.system(size: 14, weight: .bold))
						.foregroundColor(.white)
				}

				VStack(alignment: .leading, spacing: 8) {
					Text("Payment Error")
						.font(.vvSmallBold)
						.foregroundColor(Color(hex: "#C25B28"))

					Text("\(paymentError)")
						.font(.vvSmall)
						.foregroundColor(Color(hex: "#C25B28"))
						.fixedSize(horizontal: false, vertical: true)
				}
				Spacer()
			}
			.padding(Spacing.space12)
		}
		.frame(maxWidth: .infinity)
	}
}
