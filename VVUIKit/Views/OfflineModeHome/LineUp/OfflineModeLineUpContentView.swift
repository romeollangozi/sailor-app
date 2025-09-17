//
//  OfflineModeLineUpContentView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/14/25.
//

import SwiftUI

public struct OfflineModeLineUpContentView: View {

	private var shipTimeFormattedText: String?
	private var allAboardTimeFormattedText: String?
	private var lastUpdatedText: String?
	private var eventsByHour: [OfflineModeLineUpHourEvents]
    private var firstUpcomingEventIndex: Int?
    private var selectedDay: String?
	private var safeAreaInsets: EdgeInsets = EdgeInsets(.zero)
	private var back: () -> Void

	public var body: some View {
		ScrollView {
			OfflineModeLineUpHeader(
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
					VStack(alignment: .leading, spacing: Spacing.space16) {
						events()
					}.background(Color.white)
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

	private func events() -> some View  {
		VStack(alignment: .leading, spacing: Spacing.space24) {
			if eventsByHour.count == 0 {
				OfflineModeLineUpEmptyView()
			} else {
                ForEach(Array(eventsByHour.enumerated()), id: \.element.id) { index, item in
                    OfflineModeEventsByHour(lineUpEvents: item, shipTimeFormattedText: shipTimeFormattedText, showMustSeeEventCard: index == firstUpcomingEventIndex, selectedDay: selectedDay)
				}
			}
		}
		.padding(Spacing.space16)
		.frame(maxWidth: .infinity)
	}

	public init(
		shipTimeFormattedText: String? = nil,
		allAboardTimeFormattedText: String? = nil,
		lastUpdatedText: String? = nil,
		eventsByHour: [OfflineModeLineUpHourEvents] = [],
        firstUpcomingEventIndex: Int? = nil,
        selectedDay: String? = nil,
		safeAreaInsets: EdgeInsets,
		back: @escaping () -> Void = {}
	) {
		self.shipTimeFormattedText = shipTimeFormattedText
		self.allAboardTimeFormattedText = allAboardTimeFormattedText
		self.lastUpdatedText = lastUpdatedText
		self.eventsByHour = eventsByHour
        self.firstUpcomingEventIndex = firstUpcomingEventIndex
        self.selectedDay = selectedDay
		self.safeAreaInsets = safeAreaInsets
		self.back = back
	}
}


private struct OfflineModeEventsByHour: View {
	let lineUpEvents: OfflineModeLineUpHourEvents
    private var shipTimeFormattedText: String?
    private var showMustSeeEventCard: Bool
    private var selectedDay: String?

    init(lineUpEvents: OfflineModeLineUpHourEvents, shipTimeFormattedText: String? = nil, showMustSeeEventCard: Bool = false, selectedDay: String? = nil) {
		self.lineUpEvents = lineUpEvents
        self.shipTimeFormattedText = shipTimeFormattedText
        self.showMustSeeEventCard = showMustSeeEventCard
        self.selectedDay = selectedDay
	}

	var body: some View {
        VStack {
            if showMustSeeEventCard && !lineUpEvents.mustSeeEvents.isEmpty {
                mustSeeEventCardView()
            }
		ZStack(alignment: .leading) {
			VStack {
				Spacer()
					.frame(height: 10)

				DottedLine()
					.stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
					.foregroundColor(Color.mediumGray)
					.frame(width: 1)
					.frame(maxHeight: .infinity)
			}
			.padding(.leading, 20)

            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: Spacing.space12) {
                    Circle()
                        .fill(Color.mediumGray)
                        .frame(width: 10, height: 10)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(lineUpEvents.time)
                            .font(.vvHeading5)
                            .foregroundColor(Color.vvBlack)
                    }
                }
                .padding(.leading, Spacing.space16)
                
                VStack(spacing: Spacing.space16) {
                    ForEach(lineUpEvents.events) { item in
                        eventCardView(item: item)
                    }
                }
                .frame(maxWidth: .infinity)
            }
			}
		}
	}

	private func eventCardView(item: OfflineModeLineUpEvent) -> some View {
		EventCard(name: item.name,
				  timePeriod: item.timePeriod,
				  location: item.location)
	}
    
    private func mustSeeEventCardView() -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(spacing: .zero) {
                Text("\(selectedDay ?? "")'s Must-See Events")
                    .font(.vvHeading5Bold)
                
                Spacer()
            }
            .padding(.vertical, Spacing.space12)
            .padding(.horizontal, Spacing.space16)
            .background(Color.rubyRed)
            
            ForEach(lineUpEvents.mustSeeEvents.prefix(5), id: \.id) { item in
                HStack(spacing: Spacing.space16) {
                    Text(item.name)
                        .font(.vvSmallBold)
                        .foregroundColor(Color.blackText)
                    
                    Spacer()
                    
                    Text(item.timePeriod)
                        .font(.vvSmallBold)
                        .foregroundColor(Color.blackText)
                }
                .padding(.horizontal, Spacing.space16)
                .padding(.top, Spacing.space8)
                .padding(.bottom, Spacing.space12)
            }
        }
        .padding(.bottom, Spacing.space8)
        .foregroundStyle(.white)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Spacing.space8))
        .overlay(
            RoundedRectangle(cornerRadius: Spacing.space8)
                .stroke(Color.iconGray, lineWidth: 1)
        )
    }
}

public struct OfflineModeLineUpHourEvents: Identifiable {
	public var id: UUID = UUID()
	public var time: String
	public var events: [OfflineModeLineUpEvent]
    public var mustSeeEvents: [OfflineModeLineUpEvent]

	public init(time: String, events: [OfflineModeLineUpEvent], mustSeeEvents: [OfflineModeLineUpEvent]) {
		self.time = time
		self.events = events
        self.mustSeeEvents = mustSeeEvents
	}
}

public struct OfflineModeLineUpEvent: Identifiable {
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

struct OfflineModeLineUpEmptyView: View {
	public var body: some View {
		VStack(alignment: .center, spacing: 16) {
			Image(systemName: "info.circle")
				.resizable()
				.renderingMode(.template)
				.foregroundColor(Color.slateGray)
				.aspectRatio(contentMode: .fit)
				.frame(height: 48)
			Text("We seem to have had a problem saving today’s line-up before you left the ship.")
				.font(.vvBody)
				.foregroundColor(Color.slateGray)
				.multilineTextAlignment(.center)
		}
		.padding(.vertical, 40.0)
		.padding(.horizontal, 24.0)
	}
}

struct OfflineModeLineUpContentView_Previews: PreviewProvider {
	static var previews: some View {
		OfflineModeLineUpContentView(
			shipTimeFormattedText: "5:50pm",
			allAboardTimeFormattedText: "6:00pm",
			lastUpdatedText: "5:50pm",
			eventsByHour: [
				OfflineModeLineUpHourEvents(time: "9:00am",
											events: [
												OfflineModeLineUpEvent(
													name: "Mind Benders — Puzzles & Crosswords",
													timePeriod: "1-2pm",
													location: "The social club, Deck 7"
												),
												OfflineModeLineUpEvent(
													name: "Mind Benders — Puzzles & Crosswords",
													timePeriod: "2-3pm",
													location: "The social club, Deck 7"
												)
                                            ], mustSeeEvents: [
                                                OfflineModeLineUpEvent(
                                                    name: "Mind Benders — Puzzles & Crosswords",
                                                    timePeriod: "1-2pm",
                                                    location: "The social club, Deck 7"
                                                ),
                                                OfflineModeLineUpEvent(
                                                    name: "Mind Benders — Puzzles & Crosswords",
                                                    timePeriod: "2-3pm",
                                                    location: "The social club, Deck 7"
                                                )
                                            ]
										   ),
				OfflineModeLineUpHourEvents(time: "10:00am",
											events: [
												OfflineModeLineUpEvent(
													name: "Mind Benders — Puzzles & Crosswords",
													timePeriod: "1-2pm",
													location: "The social club, Deck 7"
												),
												OfflineModeLineUpEvent(
													name: "Mind Benders — Puzzles & Crosswords",
													timePeriod: "2-3pm",
													location: "The social club, Deck 7"
												)
                                            ], mustSeeEvents:  [
                                                OfflineModeLineUpEvent(
                                                    name: "Mind Benders — Puzzles & Crosswords",
                                                    timePeriod: "1-2pm",
                                                    location: "The social club, Deck 7"
                                                ),
                                                OfflineModeLineUpEvent(
                                                    name: "Mind Benders — Puzzles & Crosswords",
                                                    timePeriod: "2-3pm",
                                                    location: "The social club, Deck 7"
                                                )
                                            ]
										   )
			],
			safeAreaInsets: EdgeInsets(.zero)
		)
	}
}
