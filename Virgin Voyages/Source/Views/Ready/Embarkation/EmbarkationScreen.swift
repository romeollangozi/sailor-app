//
//  EmbarkationScreen.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/21/24.
//

import SwiftUI

struct EmbarkationScreen: View {
	@State var embarkation: EmbarkationTask
		
	var body: some View {
		ZStack {
			switch embarkation.step {
			case .areYouFlyingIn:
				EmbarkationArrivalStep()
					.background(embarkation.backgroundColor)
				
			case .flyingInDetails:
				EmbarkationFlightStep(flight: $embarkation.arrivalFlight) {
					embarkation.flyingIn = .complete
				}
				.background(embarkation.backgroundColor)
				
			case .flyingOutDetails:
                EmbarkationFlightStep(flight: $embarkation.departureFlight, isOutbound: true) {
					embarkation.flyingOut = .complete
				}
				.background(embarkation.backgroundColor)
				
			case .areYouFlyingOut:
				EmbarkationDepartureStep()
					.background(embarkation.backgroundColor)
				
			case .priorityBoarding(let page):
				EmbarkationPriorityBoardingStep(page: page)
					.background(embarkation.backgroundColor)
				
			case .standardBoarding:
				EmbarkationStandardBoardingStep()
					.background(embarkation.backgroundColor)
				
			case .arrivingWithYou:
				EmbarkationArrivingCabinMatesStep()
					.background(embarkation.backgroundColor)
				
			case .leavingWithYou:
				EmbarkationLeavingCabinMatesStep()
					.background(embarkation.backgroundColor)
				
			case .carServiceRequest:
				EmbarkationCarServiceRequestStep()
					.background(embarkation.backgroundColor)
				
			case .carServiceForm:
				EmbarkationCarServiceFormStep()
					.background(embarkation.backgroundColor)
				
			case .parking:
				EmbarkationParkStep()
					.background(embarkation.backgroundColor)
				
			case .save:
				ProgressView()
					.background(embarkation.backgroundColor)
				
			case .review:
				EmbarkationReviewStep()
			}
		}
		.environment(embarkation)
		.sailableToolbar(task: embarkation)
	}
}
