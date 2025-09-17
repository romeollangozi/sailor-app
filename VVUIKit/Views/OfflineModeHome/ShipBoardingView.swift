//
//  ShipBoardingView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/19/25.
//

import SwiftUI

struct ShipBoardingView: View {

	private let allAboardTimeFormattedText: String

	var body: some View {
		ZStack {
			Color.white.edgesIgnoringSafeArea(.all)

			VStack(spacing: 24) {
				// Ship icon
				Image(systemName: "ferry.fill")
					.resizable()
					.scaledToFit()
					.frame(width: 60, height: 40)
					.foregroundColor(Color.gray)
					.padding(.top, 40)

				// Main heading
				Text("All aboard by \(allAboardTimeFormattedText)\nShip Time")
					.font(.vvHeading3Bold)
					.foregroundColor(.blackText)
					.multilineTextAlignment(.center)
					.padding(.top, 8)

				// Explanatory text
				Text("You'll need to be back on board at \(allAboardTimeFormattedText) to make sure we don't leave without you.")
					.font(.vvBody)
					.foregroundColor(.slateGray)
					.multilineTextAlignment(.center)
					.padding(.horizontal, 20)
					.padding(.top, 8)

				Spacer()
			}
			.padding()
		}
	}

	init(allAboardTimeFormattedText: String) {
		self.allAboardTimeFormattedText = allAboardTimeFormattedText
	}
}

struct ShipBoardingView_Previews: PreviewProvider {
	static var previews: some View {
		ShipBoardingView(allAboardTimeFormattedText: "6:30pm")
	}
}
