//
//  ClarificationStatesSheet.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 1.5.25.
//

import SwiftUI
import VVUIKit

struct ClarificationStatesSheet: View {
	let conflict: BookableConflictsModel.HardConflictDetails
	let onDismiss: VoidCallback?
	
	init(conflict: BookableConflictsModel.HardConflictDetails, onDismiss: VoidCallback? = nil) {
		self.conflict = conflict
		self.onDismiss = onDismiss
	}
	
	var body: some View {
		VStack {
			toolbar()
			
			OverlappingImagesScrollView(imageUrls: conflict.sailorsPhotos)
				.padding()
			
			Text(conflict.title)
				.font(.vvHeading3Bold)
				.padding()
			
			BoldedTextView(text: conflict.description, placeholders: conflict.sailorsNames)
				.padding(.horizontal)
			
			
			SecondaryButton("Ok, got it") {
				onDismiss?()
			}
			
			Spacer()
		}
	}
	
	private func toolbar() -> some View {
		HStack {
			BackButton {
				onDismiss?()
			}
			.padding()
			
			Spacer()
		}
	}
}

//#Preview("Clarification States for logged in user") {
//	ScrollView {
//		ClarificationStatesSheet(viewModel: ClarificationStatesSheetPreviewViewModel())
//	}
//}
//
//#Preview("Clarification States for one other user") {
//	ScrollView {
//		ClarificationStatesSheet(viewModel: ClarificationStatesSheetPreviewViewModel(clarificationStates: .init(clarificationTitle: "Hold Up",
//					clarificationText: "John already has something booked at this time. You can’t double book them.",
//					sailorPhotos: [""],
//					sailorNames: ["John"])))
//	}
//}
//
//#Preview("Clarification States for more than one user") {
//	ScrollView {
//		ClarificationStatesSheet(viewModel: ClarificationStatesSheetPreviewViewModel(clarificationStates: .init(clarificationTitle: "Hold Up",
//					clarificationText: "John and Anna already has something booked at this time. You can’t double book them.",
//					sailorPhotos: [""],
//					sailorNames: ["John", "Anna"])))
//	}
//}

