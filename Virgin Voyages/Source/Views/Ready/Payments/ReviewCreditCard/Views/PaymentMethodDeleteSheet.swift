//
//  PaymentMethodDeleteSheet.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/21/24.
//

import SwiftUI

@Observable class PaymentMethodDeleteSheetViewModel {
	var paymentMethodModel: PaymentMethodModel
	var deletePaymentMethodUseCase: DeletePaymentMethodUseCase

	var heading: String {
		paymentMethodModel.creditCardPages.deleteCardModal.title
	}

	var caption: String {
		paymentMethodModel.creditCardPages.deleteCardModal.description
	}

    init(paymentMethodModel: PaymentMethodModel, deletePaymentMethodUseCase: DeletePaymentMethodUseCase) {
		self.paymentMethodModel = paymentMethodModel
		self.deletePaymentMethodUseCase = deletePaymentMethodUseCase
	}

	func deletePaymentMethod() async -> Bool {
        return await deletePaymentMethodUseCase.execute(paymentMethodModel: paymentMethodModel, paymentType: .creditCard)
	}
}

struct PaymentMethodDeleteSheet: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.contentSpacing) var spacing
	@State private var deleteTask = ScreenTask()
	@State var viewModel: PaymentMethodDeleteSheetViewModel

	init(viewModel: PaymentMethodDeleteSheetViewModel) {
		_viewModel = State(wrappedValue: viewModel)
	}

	var body: some View {
		VStack(alignment: .center, spacing: spacing) {
			header
			description
			confirmationButtons
		}
		.padding(spacing * 2)
	}

	// MARK: - Subviews
	private var header: some View {
		Text(viewModel.heading)
			.fontStyle(.largeTitle)
			.multilineTextAlignment(.center)
	}

	private var description: some View {
		Text(viewModel.caption)
			.fontStyle(.body)
			.foregroundStyle(.secondary)
			.multilineTextAlignment(.center)
	}

	private var confirmationButtons: some View {
		VStack(spacing: spacing) {
			TaskButton(title: "Yes, I'm sure", task: deleteTask) {
				await viewModel.deletePaymentMethod()
				dismiss()
			}
			.buttonStyle(PrimaryButtonStyle())

			Button("No, cancel") {
				dismiss()
			}
			.buttonStyle(TertiaryButtonStyle())
		}
	}
}
