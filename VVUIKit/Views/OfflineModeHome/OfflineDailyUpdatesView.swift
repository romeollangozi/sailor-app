//
//  OfflineDailyUpdatesView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/19/25.
//

import SwiftUI

struct OfflineDailyUpdatesView: View {

	private var lastUpdatedText: String?
	private var navigateToAgenda: () -> Void
	private var navigateToEventLineup: () -> Void
	private var navigateToConnectToWiFi: (() -> Void)

	var body: some View {
		ZStack {
			Rectangle()
				.foregroundColor(.white)
				.clipShape(RoundedCorners(topLeft: 16,
										  topRight: 16,
										  bottomLeft: 0,
										  bottomRight: 0))
			VStack(spacing: Spacing.space16) {
				if let lastUpdatedText = lastUpdatedText {
					LastUpdatedView(lastUpdatedText: lastUpdatedText)
				}
				VStack(spacing: 16) {
					OfflineDailyUpdateCard(image: .agendaIcon, title: "Your Day’s Agenda") {
						navigateToAgenda()
					}
					OfflineDailyUpdateCard(image: .lineUpIcon, title: "Today’s Event Line-up") {
						navigateToEventLineup()
					}
				}
				.padding(.top, Spacing.space8)
				ConnectToWiFiSection {
					navigateToConnectToWiFi()
				}
			}
			.padding(.top, 20.0)
		}
	}

	init(
		lastUpdatedText: String? = nil,
		navigateToAgenda: @escaping () -> Void,
		navigateToEventLineup: @escaping () -> Void,
		navigateToConnectToWiFi: @escaping () -> Void
	) {
		self.lastUpdatedText = lastUpdatedText
		self.navigateToAgenda = navigateToAgenda
		self.navigateToEventLineup = navigateToEventLineup
		self.navigateToConnectToWiFi = navigateToConnectToWiFi
	}
}

struct OfflineDailyUpdatesView_Previews: PreviewProvider {
	static var previews: some View {
		OfflineDailyUpdatesView(navigateToAgenda: {
		}, navigateToEventLineup: {
		}, navigateToConnectToWiFi: {
		})
	}
}
