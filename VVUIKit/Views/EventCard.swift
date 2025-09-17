//
//  EventCard.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 7.3.25.
//

import SwiftUI

public struct EventCard: View {
	let name: String
	let timePeriod: String
	let location: String
	let isBookable: Bool
	let isBooked: Bool
	let isDisabled: Bool
	let isNonInventoried: Bool
	let slotStatusText: String?
	let imageUrl: String?
	let price : String?

	public init(
		name: String,
		timePeriod: String,
		location: String,
		isBookable: Bool = false,
		isBooked: Bool = false,
		isDisabled: Bool = false,
		isNonInventoried: Bool = true,
		slotStatusText: String? = nil,
		imageUrl: String? = nil,
		price: String? = nil
	) {
		self.name = name
		self.timePeriod = timePeriod
		self.location = location
		self.isBookable = isBookable
		self.isBooked = isBooked
		self.isDisabled = isDisabled
		self.isNonInventoried = isNonInventoried
		self.slotStatusText = slotStatusText
		self.imageUrl = imageUrl
		self.price = price

	}

	public var body: some View {
        HStack(spacing: Spacing.space0) {

			if isBookable {
				ZStack(alignment: .bottomLeading) {
					if let imageUrl = imageUrl {
						FlexibleProgressImage(url: URL(string: imageUrl))
							.frame(maxWidth: .infinity)
							.clipShape(RoundedCorners(
								topLeft: 12,
								topRight: 0,
								bottomLeft: 12,
								bottomRight: 0
							))
							.grayscale(isDisabled ? 1.0 : 0.0)
					}

					if(isDisabled) {
						if let slotStatusText = slotStatusText, !slotStatusText.isEmpty {
							MessageBar(style: MessageBarStyle.Dark, text: slotStatusText)
						}
					} else {
						if let priceValue = price, !priceValue.isEmpty {
							MessageBar(style: MessageBarStyle.Purple, text: priceValue)
						}
					}

				}.frame(maxWidth: UIScreen.main.bounds.width * ScreenWidth.oneThird)
			}

			VStack(alignment: .leading, spacing: Spacing.space4) {
				HStack {
					Text(timePeriod)
						.font(.vvSmallBold)
						.foregroundColor(Color.deepPurple)
                        .lineLimit(1)

					Spacer()

					if isBooked {
						Badge(style: isNonInventoried ? .Info : .Success, text: isNonInventoried ? "Added" : "Booked")
					}
				}

				Text(name)
					.font(.vvHeading5Bold)
					.fontWeight(.bold)
					.foregroundColor(Color.vvBlack)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)

				Text(location)
					.font(.vvSmall)
					.foregroundColor(Color.slateGray)
                    .lineLimit(1)
			}
            .padding(Spacing.space16)
		}
		.background(Color.white)
		.cornerRadius(8)
		.shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 1)
		.shadow(color: Color.black.opacity(0.07), radius: 48, x: 0, y: 8)
	}
}

#Preview("Event cards") {
	ScrollView {
		VStack(spacing: Spacing.space16) {
			EventCard(
				name: "The Charmer's Lounge",
				timePeriod: "1-1:30pm",
				location: "The Dock House, Deck 7",
				isBookable: false)

			EventCard(
				name: "Squid Ink Tattos & Piercings - Bookings Now Open",
				timePeriod: "1-1:30pm",
				location: "The Dock House, Deck 7",
				isBookable: true,
				imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:54d66526-e3b5-4adb-bf6f-271178c541c9/IMG-ENT-The-Charmers-Lounge-1200x800.jpg")

			
			EventCard(
				name: "The Charmer's Lounge",
				timePeriod: "1-1:30pm",
				location: "The Dock House, Deck 7",
				isBookable: true,
				imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:54d66526-e3b5-4adb-bf6f-271178c541c9/IMG-ENT-The-Charmers-Lounge-1200x800.jpg")

			EventCard(
				name: "The Charmer's Lounge",
				timePeriod: "1-1:30pm",
				location: "The Dock House, Deck 7",
				isBookable: true,
				isBooked: true,
				imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:54d66526-e3b5-4adb-bf6f-271178c541c9/IMG-ENT-The-Charmers-Lounge-1200x800.jpg")

			EventCard(
				name: "The Charmer's Lounge",
				timePeriod: "1-1:30pm",
				location: "The Dock House, Deck 7",
				isBookable: true,
				isBooked: true,
				isNonInventoried: false,
				imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:54d66526-e3b5-4adb-bf6f-271178c541c9/IMG-ENT-The-Charmers-Lounge-1200x800.jpg")

			EventCard(
				name: "The Charmer's Lounge",
				timePeriod: "1-1:30pm",
				location: "The Dock House, Deck 7",
				isBookable: true,
				isDisabled: true,
				imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:54d66526-e3b5-4adb-bf6f-271178c541c9/IMG-ENT-The-Charmers-Lounge-1200x800.jpg")

			EventCard(
				name: "The Charmer's Lounge",
				timePeriod: "1-1:30pm",
				location: "The Dock House, Deck 7",
				isBookable: true,
				isDisabled: false,
				imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:54d66526-e3b5-4adb-bf6f-271178c541c9/IMG-ENT-The-Charmers-Lounge-1200x800.jpg",
				price: "$29.99")

		}.padding(Spacing.space16)
	}
}
