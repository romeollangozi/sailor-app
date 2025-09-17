//
//  VoyageUpdatingView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 7/14/25.
//

import SwiftUI
import VVUIKit

struct VoyageUpdatingView: View {
	@State var viewModel: VoyageUpdatingViewModel

	init(viewModel: VoyageUpdatingViewModel = VoyageUpdatingViewModel()) {
		_viewModel = State(wrappedValue: viewModel)
	}

	var body: some View {
		VStack(spacing: Spacing.space24) {
			// Title
			Text("Updating Voyage Details")
				.font(.vvHeading1Bold)
				.multilineTextAlignment(.center)
				.padding(.top, Spacing.space40)

			// Description
			Text("We're updating your voyage details due to an itinerary change. Please try again later, and/or contact sailor services for further information.")
				.font(.vvHeading5)
				.multilineTextAlignment(.center)

			Spacer()

			Image(.clearPastVoyages)
				.resizable()
				.scaledToFit()
				.frame(height: 200)

			Spacer()

			// Log Out Button
			Button("Log Out") {
				viewModel.logOut()
			}
			.buttonStyle(SecondaryButtonStyle())
			.padding(.bottom, Spacing.space40)
		}
		.padding(.horizontal, Spacing.space24)
		.background(Color.beige)
	}
}

struct VoyageUpdatingView_Previews: PreviewProvider {
	static var previews: some View {
		VoyageUpdatingView()
	}
}
