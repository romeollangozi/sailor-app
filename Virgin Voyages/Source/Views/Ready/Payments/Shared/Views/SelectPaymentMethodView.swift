//
//  SelectPaymentMethodView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/23/24.
//

import SwiftUI
import VVUIKit

protocol SelectPaymentMethodViewModelProtocol {
	var showInfoSheet: Bool { get set }
	var imageURL: URL? { get set }
	var backgroundColor: Color { get set }

	var questionText: String { get }
	var availablePaymentMethods: [PaymentMethodPickerPaymentMethodViewModelProtocol] { get }

	var paymentInfoSheetTitle: String { get }
	var paymentInfoSheetDescription: String { get }
	var paymentInfoSheetOkayMessageText: String { get }

	func toggleInfoSheet()
}

struct SelectPaymentMethodView: View {

	@State private var viewModel: SelectPaymentMethodViewModelProtocol
	@Environment(\.contentSpacing) var spacing

	private var selectedPaymentMethodAtIndex: ((Int) -> Void)?

	init(viewModel: SelectPaymentMethodViewModelProtocol,
		 selectedPaymentMethodAtIndex: ((Int) -> Void)? = nil) {
		_viewModel = State(wrappedValue: viewModel)
		self.selectedPaymentMethodAtIndex = selectedPaymentMethodAtIndex
	}

	var body: some View {
		VStack(alignment: .leading, spacing: spacing * 2) {
			Spacer()
			sailTaskImageView()
			Spacer()
			infoButton()
			PaymentMethodPicker(viewModel: PaymentMethodPickerViewModel(availablePaymentMethods: viewModel.availablePaymentMethods)) { index in
				selectedPaymentMethodAtIndex?(index)
			}
		}
		.sailableStepStyle()
		.background(viewModel.backgroundColor)
		.sheet(isPresented: $viewModel.showInfoSheet) {
			paymentInfoSheet()
		}
	}

	@ViewBuilder
	private func sailTaskImageView() -> some View {
		AsyncImage(url: viewModel.imageURL) { image in
			image
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: 320, height: 320)
		} placeholder: {
			ProgressView()
		}
	}

	@ViewBuilder
	private func infoButton() -> some View {
		Button {
			viewModel.toggleInfoSheet()
		} label: {
			Label(viewModel.questionText, systemImage: "info.circle.fill")
                .fixedSize(horizontal: false, vertical: true)
		}
		.tint(.primary)
        .font(.vvHeading5Bold)
	}

	@ViewBuilder
    private func paymentInfoSheet() -> some View {
        InfoDrawerView(
            title: viewModel.paymentInfoSheetTitle,
            description: viewModel.paymentInfoSheetDescription,
            buttonTitle: viewModel.paymentInfoSheetOkayMessageText) {
                viewModel.toggleInfoSheet()
            }
            .presentationDetents([.medium])
    }
}

struct SelectPaymentMethodView_Previews: PreviewProvider {
	class MockPaymentMethodViewModel: SelectPaymentMethodViewModelProtocol {
		var showInfoSheet: Bool = false
		var selectedStep: PaymentMethodViewModel.Step? = .start
		var imageURL: URL? = nil
		var backgroundColor: Color = Color(hex: "8ED6EC")

		var questionText: String = "Need more info?"
		var availablePaymentMethods: [PaymentMethodPickerPaymentMethodViewModelProtocol] = [
			MockPaymentMethod(name: "Credit Card"),
			MockPaymentMethod(name: "Debit Card"),
			MockPaymentMethod(name: "PayPal")
		]

		var paymentInfoSheetTitle: String = "Payment Information"
		var paymentInfoSheetDescription: String = "Here is some important information about the payment methods available."
		var paymentInfoSheetOkayMessageText: String = "Got it!"

		func selectPaymentMethod(_ step: PaymentMethodViewModel.Step) {
			selectedStep = step
		}

		func selectPaymentMethodAtIndex(_ index: Int) {
		}

		func toggleInfoSheet() {
			showInfoSheet.toggle()
		}

		struct MockPaymentMethod: PaymentMethodPickerPaymentMethodViewModelProtocol {
			var name: String
		}
	}

	static var previews: some View {
		SelectPaymentMethodView(viewModel: MockPaymentMethodViewModel()) { selectedStep in
			print("Selected payment method step: \(selectedStep)")
		}
		.previewLayout(.sizeThatFits)
		.padding()
	}
}
