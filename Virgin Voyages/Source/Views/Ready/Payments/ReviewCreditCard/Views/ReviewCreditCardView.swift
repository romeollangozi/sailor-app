//
//  ReviewCreditCardView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/14/24.
//

import SwiftUI

struct ReviewCreditCardView: View {
	@Environment(\.contentSpacing) var spacing
	@State private var viewModel: ReviewCreditCardViewModel

	var pressedEditCard: (() -> Void)?
	var dismiss: (() -> Void)?

	init(viewModel: ReviewCreditCardViewModel,
		 pressedEditCard: (() -> Void)? = nil,
		 dismiss: (() -> Void)?) {
		_viewModel = State(wrappedValue: viewModel)
		self.pressedEditCard = pressedEditCard
		self.dismiss = dismiss
	}

	var body: some View {
		SailableReviewStepScrollable(imageUrl: viewModel.imageURL) {
			Text("Payment Card")
				.fontStyle(.largeTitle)

			cardSection

			if viewModel.paymentMethodModel.dependents.count > 0 {
				dependentPicker
			}

			saveFooter
		}
		.background(.white)
		.animation(.easeInOut, value: viewModel.expanded)
		.sheet(isPresented: $viewModel.showDeleteSheet) {
			deleteSheet
		}
		.onChange(of: viewModel.shouldDismiss) {
			dismiss?()
		}
	}

	// MARK: - Subviews
	private var cardSection: some View {
		VStack(alignment: .leading, spacing: 40) {
			VStack(alignment: .trailing, spacing: spacing) {
				PaymentMethodCreditCardLabel(
					cardNumber: viewModel.cardNumber.maskedExceptLastFour(),
					name: viewModel.name.maskedByWord(),
					expiryMonth: viewModel.expiryMonth,
					expiryYear: viewModel.expiryYear
				)

				editButton
			}
		}
	}

	private var editButton: some View {
		Button {
			pressedEditCard?()
		} label: {
			Label("Edit", systemImage: "pencil.circle")
				.imageScale(.large)
				.fontStyle(.body)
		}
	}

	private var dependentPicker: some View {
		PaymentMethodDependentPicker(
			viewModel: PaymentMethodDependentPickerViewModel(
				paymentMethodModel: viewModel.paymentMethodModel
			)
		)
		.disabled(viewModel.disabled)
	}

	private var saveFooter: some View {
		PaymentMethodSaveFooter(
			saveable: viewModel.saveable,
			showChangePaymentMethod: viewModel.showChangePaymentMethod,
			saveLoading: viewModel.saveLoading,
			save: { viewModel.save() },
			changePaymentMethod: { viewModel.changePaymentMethod() },
			onCancel: { viewModel.dismiss() }
		)
		.disabled(viewModel.disabled)
	}

	private var deleteSheet: some View {
		let deleteViewModel = PaymentMethodDeleteSheetViewModel(
			paymentMethodModel: viewModel.paymentMethodModel,
			deletePaymentMethodUseCase: viewModel.deletePaymentMethodUseCase
		)
		return PaymentMethodDeleteSheet(viewModel: deleteViewModel)
	}
}
