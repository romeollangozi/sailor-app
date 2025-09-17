//
//  OfflineModeMyAgendaContentView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/7/25.
//

import SwiftUI

public struct OfflineModeMyAgendaEventCardModel: Identifiable {
	public var id: UUID = UUID()
	public var name: String
	public var timePeriod: String
	public var location: String

	public init(id: UUID = UUID(), name: String, timePeriod: String, location: String) {
		self.id = id
		self.name = name
		self.timePeriod = timePeriod
		self.location = location
	}
}

public struct OfflineModeMyAgendaContentView: View {

	private var shipTimeFormattedText: String?
	private var allAboardTimeFormattedText: String?
	private var lastUpdatedText: String?
	private var eventCardModels: [OfflineModeMyAgendaEventCardModel]
	private var safeAreaInsets: EdgeInsets = EdgeInsets(.zero)
	private var back: () -> Void

	public var body: some View {
		ScrollView {
			OfflineModeMyAgendaHeader(
				safeAreaInsets: safeAreaInsets,
				back: {
					back()
				}
			)
			VStack(spacing: 0) {
				VStack(spacing: 16) {
					if let lastUpdatedText = lastUpdatedText {
						LastUpdatedView(lastUpdatedText: lastUpdatedText)
					}
					if eventCardModels.count == 0 {
						OfflineModeMyAgendaEmptyView()
					} else {
						ForEach(eventCardModels) { model in
							EventCard(name: model.name,
									  timePeriod: model.timePeriod,
									  location: model.location)
						}
					}
				}
				.padding(Spacing.space16)
				.background(Color.white)
				DoubleDivider()
					.background(Color.white)
				if let allAboardTimeFormattedText = allAboardTimeFormattedText {
					ShipBoardingView(allAboardTimeFormattedText: allAboardTimeFormattedText)
				}
			}
		}
		.ignoresSafeArea(.all)
	}

	public init(
		shipTimeFormattedText: String? = nil,
		allAboardTimeFormattedText: String? = nil,
		lastUpdatedText: String? = nil,
		eventCardModels: [OfflineModeMyAgendaEventCardModel] = [],
		safeAreaInsets: EdgeInsets,
		back: @escaping () -> Void = {}
	) {
		self.shipTimeFormattedText = shipTimeFormattedText
		self.allAboardTimeFormattedText = allAboardTimeFormattedText
		self.lastUpdatedText = lastUpdatedText
		self.eventCardModels = eventCardModels
		self.safeAreaInsets = safeAreaInsets
		self.back = back
	}
}

struct OfflineModeMyAgendaEmptyView: View {
	public var body: some View {
		VStack(alignment: .center, spacing: 16) {
			Image(systemName: "calendar")
				.resizable()
				.renderingMode(.template)
				.foregroundColor(Color.slateGray)
				.aspectRatio(contentMode: .fit)
				.frame(height: 48)
			Text("You don’t have any bookings today, or they were made after the last update.")
				.font(.vvBody)
				.foregroundColor(Color.slateGray)
				.multilineTextAlignment(.center)
		}
		.padding(.vertical, 40.0)
		.padding(.horizontal, 24.0)
	}
}

struct OfflineModeMyAgendaContentView_Previews: PreviewProvider {
	static var previews: some View {
		OfflineModeMyAgendaContentView(
			shipTimeFormattedText: "5:50pm",
			allAboardTimeFormattedText: "6:00pm",
			lastUpdatedText: "5:50pm",
			safeAreaInsets: EdgeInsets(.zero)
		)
	}
}
