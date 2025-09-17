//
//  ConnectToWiFiNoConnectionView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/6/25.
//

import SwiftUI
import VVUIKit

struct ConnectToWiFiNoConnectionView: View {
	@Environment(\.contentSpacing) var spacing

	private let connectToShipWiFi: VoidCallback
	private let openWiFiSettings: VoidCallback

	init(
		connectToShipWiFi: @escaping VoidCallback,
		openWiFiSettings: @escaping VoidCallback
	) {
		self.connectToShipWiFi = connectToShipWiFi
		self.openWiFiSettings = openWiFiSettings
	}

	var body: some View {
		VStack(spacing: 0) {
			Image("Connect")
				.resizable()
				.padding(60)
				.aspectRatio(1, contentMode: .fit)

			VStack(spacing: spacing) {
				Text("No data connection")
					.fontStyle(.largeTitle)

				Text("You need a data connection to use the App, Connect to a Wi-Fi network with an internet connection or use cell data")
					.fontStyle(.body)
					.multilineTextAlignment(.center)
					.lineSpacing(4)

				Spacer()

				Text("**Are you on the ship already?**")
					.fontStyle(.body)
					.lineSpacing(4)

				Button("Connect to ship Wi-Fi") {
					connectToShipWiFi()
				}
				.buttonStyle(PrimaryButtonStyle())

				Button("Connect to Wi-Fi manually") {
					openWiFiSettings()
				}
				.buttonStyle(TertiaryButtonStyle())
			}
		}
		.padding([.leading, .trailing], Spacing.space24)
	}
}
