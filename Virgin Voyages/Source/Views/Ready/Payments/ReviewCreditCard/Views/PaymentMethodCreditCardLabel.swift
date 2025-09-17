//
//  PaymentMethodCreditCardLabel.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/14/24.
//

import SwiftUI
import VVUIKit

struct PaymentMethodCreditCardLabel: View {
	var cardNumber: String
	var name: String
	var expiryMonth: String
	var expiryYear: String

	var body: some View {
		VStack(spacing: Spacing.space20) {
			cardNumberField
			nameAndExpiryFields
		}
		.cardStyle()
	}

	// MARK: - Subviews
	private var cardNumberField: some View {
		PaymentMethodCreditCardField(title: "Card number", text: cardNumber)
	}

	private var nameAndExpiryFields: some View {
		HStack(spacing: 8) {
			PaymentMethodCreditCardField(title: "Name", text: name)
			PaymentMethodCreditCardField(title: "Expiry", text: "\(expiryMonth)/\(expiryYear)")
				.frame(width: 80)
		}
	}
}

// MARK: - View Modifiers
private extension View {
	func cardStyle() -> some View {
		self
			.frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
			.fontStyle(.headline)
			.padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 30))
			.foregroundStyle(.white)
			.background(Color("AccentColor"))
			.clipShape(RoundedRectangle(cornerRadius: 8))
	}
}

#Preview {
	PaymentMethodCreditCardLabel(cardNumber: "**** **** **** 1234",
								 name: "Fred Flintstone",
								 expiryMonth: "03",
								 expiryYear: "12")
	.padding()
}
