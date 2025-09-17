//
//  EaterySlotsErrorView.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 20.5.25.
//

import SwiftUI
import VVUIKit

struct EaterySlotsErrorView : View {
	var body: some View {
		HStack(alignment:.top) {
			Text("Timeslot data unavailable. Check back later")
				.font(.vvSmall)
				.foregroundColor(Color.slateGray)
			
			Spacer()
		}
		.padding(Spacing.space16)
	}
}

#Preview("Eatery slots error view") {
	VStack(spacing: Spacing.space16) {
		EaterySlotsErrorView()
	}
}
