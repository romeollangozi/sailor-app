//
//  SomeoneElseViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/6/24.
//

import Foundation

@Observable class SomeoneElseViewModel: SomeoneElseViewModelProtocol {
	var title: String = ""
	var description: String = ""
    var imageURL: URL?
    var showChangePaymentMethodConfirmModal: Bool = false
	var shouldDismiss: Bool = false

	var saveLoading: Bool = false
	private var changePaymentMethodLoading: Bool = false

	private var paymentMethodModel: PaymentMethodModel

	var saveable: Bool {
		return paymentMethodModel.paymentDetails.selectedPaymentMethodType != .someoneElse
	}

	var showChangePaymentMethod: Bool {
		return paymentMethodModel.paymentDetails.selectedPaymentMethodType == .someoneElse
	}

	var saveFooterDisabled: Bool {
		return saveLoading || changePaymentMethodLoading
	}

	private var savePaymentMethodUseCase: SavePaymentMethodUseCase
	private var deletePaymentMethodUseCase: DeletePaymentMethodUseCase
    let completionPercentage: Double

	init(savePaymentMethodUseCase: SavePaymentMethodUseCase,
		 deletePaymentMethodUseCase: DeletePaymentMethodUseCase,
		 paymentMethodModel: PaymentMethodModel,
         completionPercentage: Double) {
		self.savePaymentMethodUseCase = savePaymentMethodUseCase
		self.deletePaymentMethodUseCase = deletePaymentMethodUseCase
		self.paymentMethodModel = paymentMethodModel
        self.completionPercentage = completionPercentage
		updateViewModel()
	}
    
    func tappedChangePaymentMethod() {
        self.showChangePaymentMethodConfirmModal = true
    }

	func confirmChangePaymentMethod() {
		changePaymentMethodLoading = true
		Task {
			let _ = await deletePaymentMethodUseCase.execute(paymentMethodModel: paymentMethodModel, paymentType: .someoneElse)
			DispatchQueue.main.async { [weak self] in
				self?.changePaymentMethodLoading = false
				self?.shouldDismiss = true
			}
		}
	}

	func save() {
		saveLoading = true
		Task {
			let _ = await savePaymentMethodUseCase.execute(paymentMethodModel: paymentMethodModel, paymentType: .someoneElse)
			DispatchQueue.main.async { [weak self] in
				self?.saveLoading = false
				self?.shouldDismiss = true
			}
		}
	}

	func dismiss() {
		self.shouldDismiss = true
	}

	func updateViewModel() {
        self.imageURL = URL(string: paymentMethodModel.someoneElsePages.reviewPage.imageURL)
        if case .someoneElse = paymentMethodModel.paymentDetails.selectedPaymentMethodType, completionPercentage == 1.0 {
            self.title = paymentMethodModel.someoneElsePages.reviewPage.title
            self.description = paymentMethodModel.someoneElsePages.reviewPage.description
        } else {
            self.title = paymentMethodModel.someoneElsePages.introPage.title
            self.description = paymentMethodModel.someoneElsePages.introPage.description
        }
	}
}
