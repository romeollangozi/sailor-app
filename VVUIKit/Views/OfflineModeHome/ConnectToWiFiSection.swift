//
//  ConnectToWiFiSection.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/19/25.
//

import SwiftUI

struct ConnectToWiFiSection: View {
	let action: (() -> Void)?

	var body: some View {
		VStack(spacing: Spacing.space16) {
			Text("If you’re onboard the Ship let’s get\nyou back on the Wi-Fi")
				.font(.vvHeading4)
				.multilineTextAlignment(.center)
			BorderedButton(text: "Connect to Ship Wi-Fi") {
				action?()
			}
		}
		.padding(.vertical, Spacing.space16)
 	}

	init(action: (() -> Void)? = nil) {
		self.action = action
	}
}

struct ConnectToWiFiSection_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ConnectToWiFiSection()
				.previewDisplayName("Default Preview")
				.padding()
				.previewLayout(.sizeThatFits)
		}
	}
}
