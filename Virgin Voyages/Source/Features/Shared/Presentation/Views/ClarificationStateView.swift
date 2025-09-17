//
//  ClarificationStateView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 20.3.25.
//

import SwiftUI
import VVUIKit

protocol ClarificationStateViewModelProtocol {
	var clarificationStateModel: ClarificationStateModel { get }
	func onAppear()
}

struct ClarificationStateView: View {

	@State var viewModel: ClarificationStateViewModelProtocol
	let back: () -> Void

	init(sailors: [ActivitiesGuest], conficts: [BookableConflicts], back: @escaping () -> Void) {
		_viewModel = State(wrappedValue: ClarificationStateViewModel(clarificationStateUseCase: ClarificationStateUseCase(conficts: conficts, sailors: sailors)))
		self.back = back
	}

    var body: some View {
		VStack {
			toolbar()
			OverlappingImagesScrollView(imageUrls: viewModel.clarificationStateModel.sailorPhotos)
				.padding()
			Text(viewModel.clarificationStateModel.clarificationTitle)
				.font(.vvHeading3Bold)
				.padding()
 
			BoldedTextView(text: viewModel.clarificationStateModel.clarificationText, placeholders: viewModel.clarificationStateModel.sailorNames)
				.padding(.horizontal)

			SecondaryButton("Ok, got it") {
				back()
			}

			if viewModel.clarificationStateModel.isCurrentSailorConfict {
				LinkButton(viewModel.clarificationStateModel.viewExistingBookingText, action: {})
				.padding(.horizontal, Spacing.space8)
			}
			Spacer()
		}
		.onAppear(){
			viewModel.onAppear()
		}
	}

	private func toolbar() -> some View {
	   HStack {
		   BackButton {
			   back()
		   }
		   .padding()
		   Spacer()
	   }
	}
}


struct ClarificationStateView_Previews: PreviewProvider {
	static var previews: some View {
		ClarificationStateView(
			sailors: [],
			conficts: [],
			back: {}
		)
	}
}
