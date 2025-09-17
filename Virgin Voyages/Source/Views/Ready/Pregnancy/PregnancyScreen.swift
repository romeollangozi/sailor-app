//
//  PregnancyScreen.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import SwiftUI

struct PregnancyScreen: View {
	@Environment(\.dismiss) var dismiss
	@State var pregnancy: PregnancyTask
	
	var body: some View {
		ZStack {
			switch pregnancy.step {
			case .start:
				PregnancyStartStep(pregnancy: pregnancy)
					.background(pregnancy.backgroundColor)
			case .numberOfWeeks:
				PregnancyWeekStep(pregnancy: pregnancy)
					.background(pregnancy.backgroundColor)
			case .fitToTravel:
				PregnancyDoneStep(pregnancy: pregnancy, page: pregnancy.content.fitToTravelPage)
					.background(pregnancy.backgroundColor)
			case .notFitToTravel:
				PregnancyDoneStep(pregnancy: pregnancy, page: pregnancy.content.notFitToTravelPage)
					.background(pregnancy.backgroundColor)
			case .unconfirmed:
				PregnancyDoneStep(pregnancy: pregnancy, page: pregnancy.content.unKnownResponsePage)
					.background(pregnancy.backgroundColor)
			case .review(let page):
				PregnancyReviewStep(pregnancy: pregnancy, page: page)
			}
		}
		.sailableToolbar(task: pregnancy)
	}
}
