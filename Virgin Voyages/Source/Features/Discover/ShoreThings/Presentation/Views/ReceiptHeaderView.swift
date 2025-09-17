//
//  ReceiptHeaderView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.11.24.
//

import SwiftUI

protocol ReceiptHeaderViewModelProtocol {
	var title: String { get }
	var types: String { get }
	var activityPictogramURL: URL? { get }
}

struct ReceiptHeaderView: View {
    let viewModel: ReceiptHeaderViewModelProtocol

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .fontStyle(.boldSectionTagline)
                    .foregroundStyle(Color.squidInk)
                Text(viewModel.types)
                    .fontStyle(.largeCaption)
                    .foregroundStyle(.black)
            }
            Spacer()
            VStack {
				if let activityPictogramURL = viewModel.activityPictogramURL {
					SVGImageView(url: activityPictogramURL)
						.frame(width: Sizes.defaultSize40, height: Sizes.defaultSize40)
				}
			}
        }
        .frame(alignment: .topLeading)
    }
}

struct ReceiptHeaderView_Previews: PreviewProvider {
	struct MockViewModel: ReceiptHeaderViewModelProtocol {
		var title: String = "Sample Title"
		var types: String = "Sample Types"
		var activityPictogramURL: URL? = nil
	}

	static var previews: some View {
		ReceiptHeaderView(viewModel: MockViewModel())
			.previewLayout(.sizeThatFits)
	}
}
