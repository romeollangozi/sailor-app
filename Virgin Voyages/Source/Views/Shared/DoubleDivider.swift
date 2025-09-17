//
//  DoubleDivider.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 2/12/24.
//

import SwiftUI

struct ThinDoubleDivider: View {
	var body: some View {
		VStack(spacing: 2) {
			Rectangle()
				.frame(height: 1)

			Rectangle()
				.frame(height: 1)
		}
		.foregroundStyle(.primary)
	}
}

struct DoubleDivider: View {
    var body: some View {
		VStack(spacing: 4) {
			Rectangle()
				.frame(height: 4)

			Rectangle()
				.frame(height: 4)
		}
		.foregroundStyle(Color(hex: "#B7B7B7"))
        .opacity(0.3)
    }
}

#Preview {
	VStack(spacing: 20) {
		ThinDoubleDivider()
		DoubleDivider()
	}
}
