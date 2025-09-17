//
//  VoyageContractSignedStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/31/24.
//

import SwiftUI

struct VoyageContractDateStep: View {
	@Environment(\.contentSpacing) var spacing
	@Bindable var contract: VoyageContractTask
	
	var body: some View {
		SailableReviewStep(imageUrl: URL(string: contract.content.contractReviewPage?.imageURL ?? "")) {
			Text(contract.content.contractReviewPage?.title ?? "")
				.fontStyle(.largeTitle)
			
			if let signDate = contract.signDate, let description = contract.content.contractReviewPage?.description {
                let date = signDate.format(.dateTitle)
                Text(description.replacingOccurrences(of: "{date}", with: date))
					.fontStyle(.body)
			}
			
			Spacer()
			
			Button("Re-sign contract") {
				contract.startInterview()
			}
			.buttonStyle(TertiaryButtonStyle())
		}
	}
}
