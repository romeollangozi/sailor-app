//
//  VoyageContractStartStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/31/24.
//

import SwiftUI

struct VoyageContractStartStep: View {
	@Environment(\.contentSpacing) var spacing
	@Bindable var contract: VoyageContractTask
	
	var body: some View {
		VStack(alignment: .center, spacing: spacing) {
			Text(contract.content.contractStartPage.title)
				.fontStyle(.largeTitle)
			Text(contract.content.contractStartPage.description)
				.fontStyle(.body)
			
			Spacer()
			
			Button("View contract") {
				contract.startInterview()
			}
			.buttonStyle(PrimaryButtonStyle())
		}
		.sailableStepStyle()
	}
}
