//
//  ClaimBookingDeactivatedAccountInfoSheet.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 12/19/24.
//

import SwiftUI
import VVUIKit

struct ClaimBookingDeactivatedAccountInfoSheet: View {

	let close: () -> Void

	init(close: @escaping () -> Void) {
		self.close = close
	}

	var body: some View {
		VStack(spacing: 0) {
			toolbar()
			deactivatedAccountInfoContent()
		}
	}

	func toolbar() -> some View {
		Toolbar(buttonStyle: .closeButton) {
			close()
		}
	}

	private func deactivatedAccountInfoContent() -> some View {
		VStack(alignment: .leading, spacing: 16.0) {
			Text("Deactivated accounts")
				.fontStyle(.mediumTitle)
				.multilineTextAlignment(.leading)

			Text("Sometimes accounts get deactivated when a sailor mistakenly claims a booking from another sailor in their cabin.\n\nAccounts can also be deactivated automatically or by sailor services if a sailor has two accounts in the system.")
				.fontStyle(.largeTagline)
				.multilineTextAlignment(.leading)
				.foregroundColor(.gray)
			Button("Got it") {
				close()
			}
			.buttonStyle(SecondaryButtonStyle())
			Spacer()
		}
		.padding(24.0)
	}
}
