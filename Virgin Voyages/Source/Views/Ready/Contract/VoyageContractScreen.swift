//
//  VoyageContractScreen.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import SwiftUI

struct VoyageContractScreen: View {
	@State var contract: VoyageContractTask
	
    var body: some View {
		ZStack {
			switch contract.step {
			case .start:
				VoyageContractStartStep(contract: contract)
			case .sign:
				VoyageContractSignStep(contract: contract)
				
			case .review:
				VoyageContractDateStep(contract: contract)
			}
		}
		.sailableToolbar(task: contract)
    }
}
