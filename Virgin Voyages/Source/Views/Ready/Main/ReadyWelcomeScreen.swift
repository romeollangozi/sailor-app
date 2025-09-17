//
//  ReadyWelcomeScreen.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/13/24.
//

import SwiftUI

@Observable class InfoSheetViewModel {
	static let shared = InfoSheetViewModel()

	var showInfoSheet: Bool = false

	init() {
		self.showInfoSheet = showInfoSheet
	}
}

struct ReadyWelcomeScreen: View {
	var infoSheetViewModel: InfoSheetViewModel = InfoSheetViewModel.shared
	@Environment(\.contentSpacing) var spacing
	var landing: ReadyToSail.LandingIntroStart
	
	var body: some View {
		ReadyLayoutView {
			Spacer()
			VStack(alignment: .leading, spacing: spacing) {
				Text(landing.title)
					.fontStyle(.boldTagline)
					.fontWeight(.bold)
					.lineSpacing(14)
					.kerning(1)
					.textCase(.uppercase)
					.foregroundColor(.white)
				Text(landing.heading)
					.fontStyle(.largeTitle)
					.fontWeight(.bold)
					.lineSpacing(10)
					.foregroundColor(.white)
				Text(landing.description.markdown)
					.fontStyle(.body)
					.fontWeight(.regular)
					.lineSpacing(6)
					.foregroundColor(.white)
			}
			.padding(.trailing, 40)
		} header: {

		} footer: {
			VStack(spacing: 0) {
				Spacer()
				HStack {
					Button {
						infoSheetViewModel.showInfoSheet = true
					} label: {
						Label(landing.question, systemImage: "info.circle")
							.fontStyle(.headline)
							.fontWeight(.bold)
							.lineSpacing(8)
							.foregroundColor(.white)
							.multilineTextAlignment(.center)
					}
					Spacer()
				}
			}
		}
		.foregroundStyle(.white)
		.tint(.white)
		.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
	}
}
