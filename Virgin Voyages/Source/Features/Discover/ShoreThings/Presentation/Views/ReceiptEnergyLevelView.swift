//
//  ReceiptEnergyLevelView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.11.24.
//

import SwiftUI
import VVUIKit

protocol ReceiptEnergyLevelViewModelProtocol {
	var durationText: String { get }
	var duration: String { get }
	var portOfCallText: String { get }
	var portName: String { get }
	var typeText: String { get }
	var types: String { get }
}

struct ReceiptEnergyLevelView: View {
    let viewModel: ReceiptEnergyLevelViewModelProtocol

    var body: some View {
        VStack(alignment: .leading) {            
            VStack(alignment: .leading) {
				Text(viewModel.durationText)
                    .fontStyle(.boldTagline)
                    .foregroundStyle(Color.slateGray)
                Text(viewModel.duration)
                    .fontStyle(.largeTagline)
            }
            .padding(.bottom, Paddings.defaultPadding8)
            
            VStack(alignment: .leading) {
                Text(viewModel.portOfCallText)
                    .fontStyle(.boldTagline)
                    .foregroundStyle(Color.slateGray)
                Text(viewModel.portName)
                    .fontStyle(.largeTagline)
            }
            .padding(.bottom, Paddings.defaultPadding8)
            
            VStack(alignment: .leading) {
                Text(viewModel.typeText)
                    .fontStyle(.boldTagline)
                    .foregroundStyle(Color.slateGray)
                Text(viewModel.types)
                    .fontStyle(.largeTagline)
            }
            .padding(.bottom, Paddings.defaultPadding8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ReceiptEnergyLevelView_Previews: PreviewProvider {

	struct MockReceiptEnergyLevelViewModel: ReceiptEnergyLevelViewModelProtocol {
		var energyLevelText: String { "Energy Level" }
		var energyLevelImageURL: URL? { nil }
		var durationText: String { "Duration" }
		var duration: String { "3 hours" }
		var portOfCallText: String { "Port of Call" }
		var portName: String { "Nassau" }
		var typeText: String { "Type" }
		var types: String { "Adventure" }
	}


	static var previews: some View {
		ReceiptEnergyLevelView(viewModel: MockReceiptEnergyLevelViewModel())
			.previewLayout(.sizeThatFits)
			.padding()
	}
}
