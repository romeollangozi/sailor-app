//
//  OfflineModeHomeContentView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/19/25.
//

import SwiftUI

public struct OfflineModeHomeContentView: View {

	private var shipTimeFormattedText: String?
	private var allAboardTimeFormattedText: String?
	private var lastUpdatedText: String?
	private var safeAreaInsets: EdgeInsets
	private var navigateToAgenda: () -> Void
	private var navigateToEventLineup: () -> Void
	private var navigateToConnectToWiFi: () -> Void


	public var body: some View {
		ScrollView {
			OfflineModeHomeHeader(
				safeAreaInsets: safeAreaInsets,
				shipTimeFormattedText: shipTimeFormattedText,
				allAboardTimeFormattedText: allAboardTimeFormattedText
			)
			VStack(spacing: 0) {
				OfflineDailyUpdatesView(
					lastUpdatedText: lastUpdatedText,
					navigateToAgenda: navigateToAgenda,
					navigateToEventLineup: navigateToEventLineup,
					navigateToConnectToWiFi: navigateToConnectToWiFi)
				DoubleDivider()
					.background(Color.white)
				if let allAboardTimeFormattedText = allAboardTimeFormattedText {
					ShipBoardingView(allAboardTimeFormattedText: allAboardTimeFormattedText)
				}
			}
			.offset(y: -30)
		}
		.ignoresSafeArea(.all)
	}

	public init(
		shipTimeFormattedText: String? = nil,
		allAboardTimeFormattedText: String? = nil,
		lastUpdatedText: String? = nil,
		safeAreaInsets: EdgeInsets = EdgeInsets(.zero),
		navigateToAgenda: @escaping () -> Void,
		navigateToEventLineup: @escaping () -> Void,
		navigateToConnectToWiFi: @escaping () -> Void
	) {
		self.shipTimeFormattedText = shipTimeFormattedText
		self.allAboardTimeFormattedText = allAboardTimeFormattedText
		self.lastUpdatedText = lastUpdatedText
		self.safeAreaInsets = safeAreaInsets
		self.navigateToAgenda = navigateToAgenda
		self.navigateToEventLineup = navigateToEventLineup
		self.navigateToConnectToWiFi = navigateToConnectToWiFi
	}
}

struct OfflineModeHomeContentView_Previews: PreviewProvider {
	static var previews: some View {
		OfflineModeHomeContentView(navigateToAgenda: {
		}, navigateToEventLineup: {
		}, navigateToConnectToWiFi: {
		})
		.previewLayout(.sizeThatFits)
	}
}
