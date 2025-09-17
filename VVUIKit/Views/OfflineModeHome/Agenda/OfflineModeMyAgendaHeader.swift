//
//  OfflineModeMyAgendaHeader.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/7/25.
//

import SwiftUI

struct OfflineModeMyAgendaHeader: View {

	private var safeAreaInsets: EdgeInsets
	private var back: () -> Void

	var body: some View {
		VStack(spacing: Spacing.space0) {
			// Empty space for top safe area
			Color.softGray.frame(height:safeAreaInsets.top)

			// Content with fixed height
			ZStack {
				VStack {
					Toolbar(buttonStyle: .backButton) {
						back()
					}
					Spacer()
				}
				VStack(spacing: 8) {
					// Calendar icon
					Image(systemName: "calendar")
						.font(.system(size: 40))
						.foregroundColor(Color.gray)
						.padding(.top, 40)

					// Title
					Text("Your Day's Agenda")
						.font(.vvHeading3Bold)
						.foregroundColor(Color.charcoalBlack)

					// Description text
					Text("For your eyes only – wait until you are back on the ship to manage your agenda.")
						.font(.vvBody)
						.foregroundColor(.slateGray)
						.multilineTextAlignment(.center)

					Spacer()
				}
				.padding(.horizontal, Spacing.space32)
			}
		}
		.frame(height: 260 + safeAreaInsets.top)
		.background(Color.softGray)
	}

	init(
		safeAreaInsets: EdgeInsets,
		back: @escaping () -> Void
	) {
		self.safeAreaInsets = safeAreaInsets
		self.back = back
	}
}
