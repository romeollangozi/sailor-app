//
//  PriceLabel.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 2/1/24.
//

import SwiftUI

struct PriceLabel: View {
	var amount: Double
    var body: some View {
		HStack(spacing: 4) {
			Text("$")
				.fontWeight(.bold)
				.foregroundStyle(.primary)
			
			HStack(spacing: 0) {
				Text(amount.priceIntegerPartText)
					.fontWeight(.bold)
					.foregroundStyle(.primary)
				
				Text(amount.priceDecimalPartText)
					.foregroundStyle(.primary)
			}
		}
    }
}

#Preview {
	PriceLabel(amount: 123.45)
}
