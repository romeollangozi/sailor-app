//
//  ConnectToWiFiTroubleshootView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 03/07/25.
//

import SwiftUI
import VVUIKit

struct ConnectToWiFiTroubleshootView: View {

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
		VStack(alignment: .center) {
			Text("Looks like you’re having trouble with ship Wi-Fi")
				.multilineTextAlignment(.center)
				.fontStyle(.largeTitle)
			
			Image("Connect")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.padding()
			
			VSpacer(spacing)
			
			Text("Let's get you connected to the Ship Wi-Fi network **'\(WiFiConstants.SSID)'**.")
				.fontStyle(.body)
			
			VSpacer(spacing)
			
			VStack(alignment: .leading, spacing: spacing) {
				Label("Wait until you are back on the ship if you are in port", systemImage: "clock")
					.fitContent()
				Label("Turn on Airplane mode", systemImage: "airplane")
				Label("Turn on Wi-Fi", systemImage: "wifi")
				Label("Turn off any VPN’s", systemImage: "network.slash")
			}
			.labelStyle(LabelListStyle())
			.fontStyle(.headline)
			
			VSpacer(spacing * 2)
			
			Button("Connect to ship Wi-Fi") {
				connectToShipWiFi()
			}
			.buttonStyle(PrimaryButtonStyle())
			
			Button("Connect to Wi-Fi manually") {
				openWiFiSettings()
			}
			.buttonStyle(TertiaryButtonStyle())
		}
		.contentStyle()
    }
}
