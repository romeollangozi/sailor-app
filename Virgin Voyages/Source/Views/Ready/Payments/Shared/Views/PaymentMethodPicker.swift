//
//  PaymentMethodPicker.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/8/24.
//

import SwiftUI

protocol PaymentMethodPickerViewModelProtocol {
	var availablePaymentMethods: [PaymentMethodPickerPaymentMethodViewModelProtocol] { get }
}

protocol PaymentMethodPickerPaymentMethodViewModelProtocol {
	var name: String { get }
}

struct PaymentMethodPicker: View {
	var viewModel: PaymentMethodPickerViewModelProtocol

	var selectPaymentMethodAtIndex: ((Int) -> Void)?

	var body: some View {
		HFlowStack(alignment: .leading) {
			ForEach(viewModel.availablePaymentMethods.indices, id: \.self) { index in
				let paymentMethod = viewModel.availablePaymentMethods[index]
				Button(paymentMethod.name) {
					selectPaymentMethodAtIndex?(index)
				}
				.buttonStyle(PrimaryCapsuleButtonStyle())
			}
		}
	}
}

struct PaymentMethodPicker_Previews: PreviewProvider {

	struct MockPaymentMethodPickerPaymentMethodViewModel: PaymentMethodPickerPaymentMethodViewModelProtocol {
		var name: String
	}

	struct MockPaymentMethodPickerViewModel: PaymentMethodPickerViewModelProtocol {
		var availablePaymentMethods: [PaymentMethodPickerPaymentMethodViewModelProtocol] = [
			MockPaymentMethodPickerPaymentMethodViewModel(name: "Credit Card"),
			MockPaymentMethodPickerPaymentMethodViewModel(name: "PayPal"),
			MockPaymentMethodPickerPaymentMethodViewModel(name: "Apple Pay")
		]
	}

	static var previews: some View {
		PaymentMethodPicker(
			viewModel: MockPaymentMethodPickerViewModel(),
			selectPaymentMethodAtIndex: { index in
				print("Selected payment method at index: \(index)")
			}
		)
		.background(Color(hex: "8ED6EC"))
		.previewLayout(.sizeThatFits)
		.padding()
	}
}
