     //
//  SomeoneElseView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/16/24.
//

import SwiftUI

protocol SomeoneElseViewModelProtocol {
	var title: String { get }
	var description: String { get }
	var imageURL: URL? { get }
	var showChangePaymentMethodConfirmModal: Bool { get set }
	var shouldDismiss: Bool { get }

	var saveLoading: Bool { get }

	var saveable: Bool { get }
	var showChangePaymentMethod: Bool { get }
	var saveFooterDisabled: Bool { get }

	func tappedChangePaymentMethod()
	func confirmChangePaymentMethod()
	func save()
	func dismiss()
	func updateViewModel()
}

struct SomeoneElseView: View {
    
	@State private var viewModel: SomeoneElseViewModelProtocol

    var dismiss: (() -> Void)?

	init(viewModel: SomeoneElseViewModelProtocol, dismiss: (() -> Void)?) {
		_viewModel = State(initialValue: viewModel)
        self.dismiss = dismiss
	}

    var body: some View {
        SailableReviewStep(imageUrl: viewModel.imageURL) {
			Text(viewModel.title)
				.fontStyle(.largeTitle)
			
			Text(viewModel.description)
                .fontStyle(.largeTagline)
                .fontWeight(.regular)
                .lineSpacing(6)
				.foregroundStyle(.gray)
			
			Spacer()

			PaymentMethodSaveFooter(saveable: viewModel.saveable,
									showChangePaymentMethod: viewModel.showChangePaymentMethod,
									saveLoading: viewModel.saveLoading) {
				viewModel.save()
			} changePaymentMethod: {
				viewModel.tappedChangePaymentMethod()
			} onCancel: {
				viewModel.dismiss()
			}.disabled(viewModel.saveFooterDisabled)
        }.fullScreenCover(isPresented: $viewModel.showChangePaymentMethodConfirmModal) {

			ErrorSheetModal(title: "Footing your own bill?",
									subheadline: "Just making sure it’s not a slip of the thumb. You’ll need to select another payment method.",
									primaryButtonText: "Yes I’m sure",
									secondaryButtonText: "Cancel") {
				viewModel.confirmChangePaymentMethod()
			} secondaryButtonAction: {
				viewModel.showChangePaymentMethodConfirmModal = false
				viewModel.dismiss()
			} dismiss: {
				viewModel.dismiss()
			}.presentationBackground(Color.black.opacity(0.75))
		}.onChange(of: viewModel.shouldDismiss) {
			if viewModel.shouldDismiss {
				dismiss?()
			}
		}
    }
}

// Preview
struct SomeoneElseView_Previews: PreviewProvider {

	class MockSomeoneElseViewModel: SomeoneElseViewModelProtocol {
		var title: String = "Sample Title"
		var description: String = "This is a sample description for the payment method."
		var imageURL: URL? = URL(string: "")
		var showChangePaymentMethodConfirmModal: Bool = false
		var shouldDismiss: Bool = false

		var saveLoading: Bool = false
		var changePaymentMethodLoading: Bool = false

		var saveable: Bool = true
		var showChangePaymentMethod: Bool = true
		var saveFooterDisabled: Bool = false

		func tappedChangePaymentMethod() {
			print("Change Payment Method Tapped")
		}

		func confirmChangePaymentMethod() {
			print("Change Payment Method Confirmed")
		}

		func save() {
			print("Save Tapped")
		}

		func dismiss() {
			print("Dismiss Tapped")
		}

		func updateViewModel() {
			// Simulate updating the view model
		}
	}

	static var previews: some View {
		SomeoneElseView(viewModel: MockSomeoneElseViewModel(), dismiss: {
			print("Dismiss action triggered")
		})
		.previewLayout(.sizeThatFits)
		.padding()
	}
}
