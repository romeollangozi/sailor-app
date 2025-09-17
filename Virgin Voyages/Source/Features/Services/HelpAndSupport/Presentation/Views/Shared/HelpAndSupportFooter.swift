//
//  HelpAndSupportFooter.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 23.4.25.
//

import SwiftUI
import VVUIKit


struct HelpAndSupportFooter: View {
	let supportPhoneNumber: String
	let sailorServiceLocation: String
	let isOnShip: Bool
	
	var body: some View {
		VStack(alignment:.center) {
			VStack(alignment:.center, spacing: Spacing.space24) {
				VStack(spacing: Spacing.space24) {
					Image(systemName: "lifepreserver")
						.resizable()
						.frame(width: 50, height: 50)
						.fontStyle(.lightBody)
					
					Text(isOnShip ? "Still need help? Come see us." : "Still need help? Give us a ring.")
						.font(.vvHeading1Bold)
						.foregroundColor(Color.vvRed)
						.frame(maxWidth: 265)
						.multilineTextAlignment(.center)
					
					if !isOnShip {
						VStack(spacing: Spacing.space24) {
							VStack {
								Text("USA & Canada")
									.font(.vvBodyBold)
									.foregroundColor(.charcoalBlack)
								
								Text(supportPhoneNumber)
									.font(.vvBody)
									.foregroundColor(.charcoalBlack)
								
								Text("8am - 9pm | EST | Monday - Friday")
									.font(.vvBody)
									.foregroundColor(.charcoalBlack)
								
								Text("9am - 6pm | EST | Saturday - Sunday")
									.font(.vvBody)
									.foregroundColor(.charcoalBlack)
							}
							
							VStack {
								Text("UK")
									.font(.vvBodyBold)
									.foregroundColor(.charcoalBlack)
								
								Text("+44 203 003 4919")
									.font(.vvBody)
									.foregroundColor(.charcoalBlack)
								
								Text("10am - 10pm | London Time | Monday - Friday")
									.font(.vvBody)
									.foregroundColor(.charcoalBlack)
								
								Text("11am - 10pm | London Time | Saturday - Sunday")
									.font(.vvBody)
									.foregroundColor(.charcoalBlack)
							}
							
							VStack {
								Text("Australia & New Zealand")
									.font(.vvBodyBold)
									.foregroundColor(.charcoalBlack)
								
								Text("+61 1800 491 708")
									.font(.vvBody)
									.foregroundColor(.charcoalBlack)
								
								Text("9am - 5pm | Sydney Time | Monday - Sunday")
									.font(.vvBody)
									.foregroundColor(.charcoalBlack)
							}
						}
					} else {
						VStack(spacing: Spacing.space8) {
							HStack {
								Image("Location")
								
								Text(sailorServiceLocation)
									.font(.vvBodyBold)
									.foregroundColor(.charcoalBlack)
							}
							Text("6am - 6pm | Ship Time | Sunday - Sunday")
								.font(.vvBody)
								.foregroundColor(.charcoalBlack)
						}
					}
				}
				.frame(maxWidth: .infinity, alignment: .center)
			}.padding(Spacing.space24)
		}.background(Color.softPink)
	}
}

#Preview("Help and support footer pre-cruise") {
	HelpAndSupportFooter(supportPhoneNumber: "+1 954 488 2955", sailorServiceLocation: "Sailor Services, Deck 5 Mid–Aft", isOnShip: false)
}

#Preview("Help and support footer on ship") {
	HelpAndSupportFooter(supportPhoneNumber: "+1 954 488 2955", sailorServiceLocation: "Sailor Services, Deck 5 Mid–Aft", isOnShip: true)
}
