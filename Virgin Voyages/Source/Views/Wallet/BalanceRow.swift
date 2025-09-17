//
//  WallerBalanceRow.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/24/24.
//

import SwiftUI

struct BalanceRow<Content>: View where Content: View {
	var header: String
	var subheader: String
	var balance: Double
	var label: () -> Content
	@State private var showContent = false
	private let backgroundColor = Color(red: 37.0 / 255.0, green: 10.0 / 255.0, blue: 51.0 / 255.0)
	
    var body: some View {
		VStack(spacing: 0) {
			Button {
				showContent.toggle()
			} label: {
				HStack {
					VStack(alignment: .leading) {
						Text(header)
						Text(subheader)
					}
					.textCase(.uppercase)
					.fontStyle(.caption)
					
					Spacer()
					
					HStack {
						PriceLabel(amount: fabs(balance))
							.fontStyle(.largeTitle)
						
						Image(systemName: "chevron.\(showContent ? "up" : "down")")
					}
				}
				.padding(35)
				.foregroundStyle(.white)
				.background(backgroundColor)
			}

			if showContent {
				label()
					.padding()
					.frame(maxWidth: .infinity)
					.background(.background)
			}
		}
		.clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
	BalanceRow(header: "Bar tab", subheader: "remaining", balance: 123.45) {
		Text("Wallet Detail")
	}
	.padding()
}
