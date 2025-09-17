//
//  ViewCreditCardView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/15/24.
//

import SwiftUI

struct ViewCreditCardView: View {
    @Environment(\.contentSpacing) var spacing

    @State private var viewModel: ViewCreditCardViewModelProtocol
    
    var pressedEditCard: (() -> Void)?
    var dismiss: (() -> Void)?

    init(viewModel: ViewCreditCardViewModel, pressedEditCard: (() -> Void)? = nil, dismiss: (() -> Void)?) {
        _viewModel = State(wrappedValue: viewModel)
        self.pressedEditCard = pressedEditCard
        self.dismiss = dismiss
    }

    var body: some View {
        SailableReviewStepScrollable(imageUrl: viewModel.imageURL) {
            Text("Payment Card")
                .fontStyle(.largeTitle)
				.padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))

            VStack(alignment: .leading, spacing: 16) {
				LockedTextField(title: "Card number", text: viewModel.cardNumber.maskedExceptLastFour())
				LockedTextField(title: "Name on card", text: viewModel.name.maskedByWord())
				LockedTextField(title: "Expiry date", text: "\(viewModel.expiryMonth)/\(viewModel.expiryYear)")
				LockedTextField(title: "Zip / Postal code", text: viewModel.zipcode.fullyMasked())
            }

            if viewModel.paymentMethodModel.dependents.count > 0 {
                PaymentMethodDependentPicker(viewModel: PaymentMethodDependentPickerViewModel(paymentMethodModel: viewModel.paymentMethodModel))
                    .disabled(viewModel.disabled)
            }

			PaymentMethodSaveFooter(saveable: viewModel.saveable,
									showChangePaymentMethod: viewModel.showChangePaymentMethod,
									saveLoading: viewModel.saveLoading) {
				viewModel.save()
			} changePaymentMethod: {
				viewModel.tappedChangePaymentMethod()
			} onCancel: {
				dismiss?()
			}.disabled(viewModel.disabled)
        }
        .animation(.easeInOut, value: viewModel.expanded)
        .sheet(isPresented: $viewModel.showDeleteSheet) {
            let viewModel = PaymentMethodDeleteSheetViewModel(paymentMethodModel: viewModel.paymentMethodModel,
                                                              deletePaymentMethodUseCase: viewModel.deletePaymentMethodUseCase)
            PaymentMethodDeleteSheet(viewModel: viewModel)
        }.onChange(of: viewModel.shouldDismiss) {
            dismiss?()
        }
    }
}
