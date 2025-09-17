//
//  PaymentSummaryLineItemView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/17/24.
//

import SwiftUI
import VVUIKit

struct PaymentSummaryLineItemView: View {
	let description: String
	let price: String

	var body: some View {
		HStack(spacing: 0) {
			Text(description)
				.fontStyle(.smallBody)
				.foregroundColor(.slateGray)
			Spacer()
			Text(price)
				.fontStyle(.smallBody)
				.foregroundColor(.slateGray)
		}
	}
}
