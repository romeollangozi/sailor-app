//
//  PurchasedLabelView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/10/24.
//

import SwiftUI

struct PurchasedLabelView: View {
	let text: String

	var body: some View {
		HStack {
			Text(text)
                .fontStyle(.boldTagline)
				.frame(height: 40)
                .padding(.horizontal, 12)
				.frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.vvDarkGray)
				.background(Color.selectedGreen)
		}
	}
}
