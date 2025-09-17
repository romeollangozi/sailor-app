//
//  PaymentMethodCreditCardField.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/16/24.
//

import SwiftUI

struct PaymentMethodCreditCardField: View {
	var title: String
	var text: String

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text(title)
				.fontStyle(.smallBody)
				.opacity(0.8)
			Text(text)
				.fontStyle(.body)
			Rectangle()
				.frame(height: 1)
		}
	}
}

#Preview {
	PaymentMethodCreditCardField(title: "Card number", text: "**** **** **** 1234")
}
