//
//  EateryLeadTimeView.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 10.4.25.
//

import SwiftUI

public struct EateryLeadTimeView: View {
	let title: String
	let subtitle: String
	let description: String
	let date: Date
	let onCalendarButtonTapped: (() -> Void)?
	
	public init(title: String, subtitle: String, description: String, date: Date, onCalendarButtonTapped: (() -> Void)? = nil) {
		self.title = title
		self.subtitle = subtitle
		self.description = description
		self.date = date
		self.onCalendarButtonTapped = onCalendarButtonTapped
	}
	
	public var body: some View {
		VStack(alignment: .center, spacing: Spacing.space20) {
			VStack {
				Image("SpoonKnife")
				
				Text(title)
					.font(.vvBodyBold)
					.foregroundColor(.black)
				
				Text(subtitle)
					.font(.vvBodyBold)
			}
			
			Text(description)
				.font(.vvBody)
				.foregroundColor(.blackText)
				.multilineTextAlignment(.center)
			
			
			HStack(spacing: Spacing.space4) {
				Image("Calendar")
				
				Button(action: {
					onCalendarButtonTapped?()
				}) {
					Text("Add to my calendar")
						.font(.vvBody)
						.underline()
				}
				.buttonStyle(.plain)
				
			}
		}
		.padding(Spacing.space20)
        .frame(maxWidth: .infinity, alignment: .center)
		.background(Color.vvTropicalBlue)
		.cornerRadius(12)
	}
}


#Preview("Eatery Lead Time") {
	ScrollView {
		VStack(spacing: Spacing.space16) {
			EateryLeadTimeView(title: "Booking opens:",
							   subtitle: "9am EST Feb 10th, 2024",
							   description: "Pop back then to make your reservations.",
							   date: Date())
		}
	}
}
