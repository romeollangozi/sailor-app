//
//  RadioButton.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/27/24.
//

import SwiftUI

struct RadioButton<Mode: Equatable>: View {
	var text: String
	@Binding var selected: Mode?
	var mode: Mode

	var body: some View {
		Button {
			selected = mode
		} label: {
			HStack(spacing: 16) {
				circle
				Text(text)
					.fontStyle(.body)
			}
		}
		.tint(.primary)
		.padding(4.0)
	}

	var circle: some View {
		ZStack {
			if selected == mode {
				Circle()
					.fill(Color("Tropical Blue"))
					.frame(width: 20, height: 20)

				Circle()
					.fill(Color(hex: "#191919"))
					.frame(width: 8, height: 8)
			} else {
				Circle()
					.stroke(Color(hex: "#8C8C8C"), lineWidth: 1)
					.frame(width: 20, height: 20)
			}
		}
	}
}

#Preview {
	EmptyView()
}
