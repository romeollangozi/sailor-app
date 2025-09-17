//
//  PriceView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/10/24.
//

import SwiftUI

struct PriceView: View {
	enum StateType {
		case available, unavailable
	}

	let price: String
	let state: StateType

	var body: some View {
		HStack {
			Text(price)
				.frame(height: 40)
				.fontStyle(.boldTagline)
				.padding(.horizontal, 12)
				.background(state == .unavailable ? Color.black : Color.squidInk)
					.foregroundColor(state == .unavailable ? .white.opacity(0.5) : .white)
		}
	}
}
