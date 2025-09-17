//
//  SelectPaymentMethodViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/6/24.
//

import SwiftUI
import Foundation



@Observable class SelectPaymentMethodViewModel: SelectPaymentMethodViewModelProtocol {
	
	var showInfoSheet = false

	private var paymentMethodModel: PaymentMethodModel

	var selectedStep: PaymentMethodViewModel.Step?

	var imageURL: URL?
	var backgroundColor: Color

	var questionText: String {
		return paymentMethodModel.paymentMethodSelectionPages.question
	}

	var availablePaymentMethods: [PaymentMethodPickerPaymentMethodViewModelProtocol] {
		return paymentMethodModel.availablePaymentMethods.map({ PaymentMethodPickerPaymentMethodViewModel(name: $0.name ) })
	}

	var paymentInfoSheetTitle: String {
		return paymentMethodModel.paymentMethodSelectionPages.paymentInfoModal.title
	}

	var paymentInfoSheetDescription: String {
		return paymentMethodModel.paymentMethodSelectionPages.paymentInfoModal.description
	}

	var paymentInfoSheetOkayMessageText: String {
		return paymentMethodModel.paymentMethodSelectionPages.paymentInfoModal.okayMessageText
	}

	init(imageURL: URL?, backgroundColor: Color, paymentMethodModel: PaymentMethodModel) {
		self.imageURL = imageURL
		self.backgroundColor = backgroundColor
		self.paymentMethodModel = paymentMethodModel
	}

	func selectPaymentMethod(_ step: PaymentMethodViewModel.Step) {
		self.selectedStep = step
	}

	func selectPaymentMethodAtIndex(_ index: Int) {
		self.selectedStep = paymentMethodModel.availablePaymentMethods[index].type.step
	}

	func toggleInfoSheet() {
		showInfoSheet.toggle()
	}
}
