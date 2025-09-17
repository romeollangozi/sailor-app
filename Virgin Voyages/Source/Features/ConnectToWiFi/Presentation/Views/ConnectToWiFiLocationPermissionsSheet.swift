//
//  ConnectToWiFiLocationPermissionsSheet.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/4/25.
//

import SwiftUI
import VVUIKit

struct ConnectToWiFiLocationPermissionsSheet: View {

	private let openSettings: VoidCallback
	private let openWiFiSettings: VoidCallback
	private let dismiss: VoidCallback

	init(
		openSettings: @escaping VoidCallback,
		openWiFiSettings: @escaping VoidCallback,
		dismiss: @escaping VoidCallback
	) {
		self.openSettings = openSettings
		self.openWiFiSettings = openWiFiSettings
		self.dismiss = dismiss
	}

	var body: some View {
		VStack(spacing: Spacing.space24) {
			Toolbar(buttonStyle: .closeButton) {
				dismiss()
			}

			Image(.path)
				.resizable()
				.aspectRatio(1, contentMode: .fit)
				.frame(width: 40, height: 37.53)

			Text("We need location permissions to connect you to Wi-Fi automatically")
				.fontStyle(.smallTitle)
				.multilineTextAlignment(.center)
				.lineLimit(nil)

			Text("This will allow us to read the names of any local networks so we can connect to \n**'VirginVoyages-Sailor'**")
				.fontStyle(.body)
				.multilineTextAlignment(.center)
				.lineLimit(nil)
				.lineSpacing(4)

			Button("Open settings") {
				openSettings()
			}
			.buttonStyle(PrimaryButtonStyle())

			Button("Connect to Wi-Fi manually") {
				openWiFiSettings()
			}
			.buttonStyle(TertiaryButtonStyle())

			Spacer()
		}
		.padding([.leading, .trailing], Spacing.space24)
	}
}
