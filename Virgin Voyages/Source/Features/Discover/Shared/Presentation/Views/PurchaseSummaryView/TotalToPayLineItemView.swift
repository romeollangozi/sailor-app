//
//  TotalToPayLineItemView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/17/24.
//

import SwiftUI
import VVUIKit

struct TotalToPayLineItemView: View {
	let price: String

	var body: some View {
		HStack(spacing: 0) {
			Text("Total to Pay")
				.fontStyle(.largeTagline)
				.foregroundColor(.blackText)
				.bold()
			Spacer()
			Text(price)
				.fontStyle(.largeTagline)
				.foregroundColor(.blackText)
				.bold()
		}
		.padding([.top, .bottom], 16)
	}
}
