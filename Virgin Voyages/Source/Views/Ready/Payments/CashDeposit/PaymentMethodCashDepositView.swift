//
//  PaymentMethodCashDepositView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/19/24.
//

import SwiftUI

protocol PaymentMethodCashDepositViewModelProtocol {
	var paymentMethodModel: PaymentMethodModel { get set }
	var expanded: Bool { get set }
	var saveLoading: Bool { get set }
	var didSaveAction: Bool { get set }
	var changePaymentMethodLoading: Bool { get set }
	var showChangePaymentMethodConfirmModal: Bool { get set }

	var disabled: Bool { get }
	var editable: Bool { get }
	var showChangePaymentMethod: Bool { get }
	var saveable: Bool { get }
	var imageURL: URL? { get }
	var title: String { get }
	var description: String { get }
	var shouldShowDependentPicker: Bool { get }

	func save()
	func tappedChangePaymentMethod()
	func confirmChangePaymentMethod()
}

struct PaymentMethodCashDepositView: View {
	@State private var viewModel: PaymentMethodCashDepositViewModelProtocol

	var dismiss: (() -> Void)?
	var goBack: (() -> Void)?

	init(
		viewModel: PaymentMethodCashDepositViewModelProtocol,
		dismiss: @escaping (() -> Void),
		goBack: @escaping (() -> Void)) {
		_viewModel = State(initialValue: viewModel)
		self.dismiss = dismiss
		self.goBack = goBack
	}

	var body: some View {
        SailableReviewStepScrollable(imageUrl: viewModel.imageURL) {
            VStack {
                content

                Spacer()
                footer
            }
            .frame(minHeight: UIScreen.main.bounds.height * 0.8)
        }
		.background(.white)
		.animation(.easeInOut, value: viewModel.expanded)
		.fullScreenCover(isPresented: $viewModel.showChangePaymentMethodConfirmModal) {
			changePaymentMethodModal
		}
		.onChange(of: viewModel.didSaveAction) {
			handleDidSaveAction()
		}
	}

	// MARK: - View Components

	private var content: some View {
		VStack(alignment: .leading, spacing: 16) {
			Text(viewModel.title)
				.fontStyle(.largeTitle)

			Text(viewModel.description)
				.foregroundStyle(.gray)

			if viewModel.shouldShowDependentPicker {
				dependentPicker
			}
		}
	}

	private var dependentPicker: some View {
		PaymentMethodDependentPicker(viewModel: PaymentMethodDependentPickerViewModel(paymentMethodModel: viewModel.paymentMethodModel))
			.disabled(viewModel.disabled)
	}

	private var footer: some View {
		PaymentMethodSaveFooter(
			saveable: viewModel.saveable,
			showChangePaymentMethod: viewModel.showChangePaymentMethod,
			saveLoading: viewModel.saveLoading,
			save: { viewModel.save() },
			changePaymentMethod: viewModel.tappedChangePaymentMethod,
			onCancel: { goBack?() }
		)
		.disabled(viewModel.disabled)
	}

	private var changePaymentMethodModal: some View {
		ErrorSheetModal(
			title: "Change payment method?",
			subheadline: "Just making sure it’s not a slip of the thumb. You will also need to reselect any dependent sailors you are footing the bill for.",
			primaryButtonText: "Yes I’m sure",
			secondaryButtonText: "No, cancel",
			primaryButtonAction: {
				viewModel.confirmChangePaymentMethod()
			},
			secondaryButtonAction: {
				viewModel.showChangePaymentMethodConfirmModal = false
			},
			dismiss: {
				dismiss?()
			}
		)
		.presentationBackground(Color.black.opacity(0.75))
	}

	// MARK: - Logic

	private func handleDidSaveAction() {
		if viewModel.didSaveAction {
			dismiss?()
		}
	}
}
