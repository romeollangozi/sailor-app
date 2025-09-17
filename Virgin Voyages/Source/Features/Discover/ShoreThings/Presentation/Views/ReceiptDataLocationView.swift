//
//  ReceiptDataLocationView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.11.24.
//

import SwiftUI

protocol ReceiptDataLocationViewModelProtocol {
	var startTime: String { get }
	var location: String { get }
}

struct ReceiptDataLocationView: View {
    let viewModel: ReceiptDataLocationViewModelProtocol

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("Calendar")
                    .frame(width: Sizes.defaultSize16, height: Sizes.defaultSize16)
                Text(viewModel.startTime)
                    .fontStyle(.largeTagline)
                Spacer()
            }
            HStack {
                Image("Location")
                    .frame(width: Sizes.defaultSize16, height: Sizes.defaultSize16)
                Text(viewModel.location)
                    .fontStyle(.largeTagline)
                Spacer()
            }
        }
        .frame(alignment: .leading)
    }
}

struct ReceiptDataLocationView_Preview: PreviewProvider {
	struct MockViewModel: ReceiptDataLocationViewModelProtocol {
		var startTime: String = "12:00 PM"
		var location: String = "Miami Port Terminal"
	}

	static var previews: some View {
		ReceiptDataLocationView(viewModel: MockViewModel())
			.previewLayout(.sizeThatFits)
			.padding()
	}
}
