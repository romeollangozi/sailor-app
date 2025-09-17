//
//  EateryBookingStoppedView.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.4.25.
//


import SwiftUI

public struct EateryBookingStoppedView: View {
	let title: String
	let description: String
	
	public init (title: String, description: String) {
		self.title = title
		self.description = description
	}
	
	public var body: some View {
		VStack(alignment: .center, spacing: Spacing.space20) {
			VStack {
				Image("SpoonKnife")
				
				Text(title)
					.font(.vvBodyBold)
					.foregroundColor(.black)
			}
			
			Text(description)
				.font(.vvBody)
				.foregroundColor(.blackText)
				.multilineTextAlignment(.center)
		}
		.padding(Spacing.space20)
        .frame(maxWidth: .infinity, alignment: .center)
		.background(Color.vvTropicalBlue)
		.cornerRadius(12)
	}
}


#Preview("Eatery Booking Stopped") {
	ScrollView {
		VStack(spacing: Spacing.space16) {
			EateryBookingStoppedView(title: "We’re moving bookings and bags",
									 description: "Our bookings are moving onto ship and will re-open on the Sailor App once you are on board.")
		}
	}
}
