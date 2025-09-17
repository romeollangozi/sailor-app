//
//  ConnectToWiFiLandingView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 03/07/25.
//

import SwiftUI
import VVUIKit

struct ConnectToWiFiLandingView: View {
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
				Text("Welcome onboard!")
					.fontStyle(.largeTitle)

				Text("Let's get you connected to the Ship Wi-Fi network **'\(WiFiConstants.SSID)'** so you can enjoy everything our ladyship has to offer.")
					.fontStyle(.body)
					.lineSpacing(4)

				Spacer()

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
