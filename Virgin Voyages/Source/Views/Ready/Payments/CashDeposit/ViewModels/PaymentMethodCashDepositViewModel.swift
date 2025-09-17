//
//  PaymentMethodCashDepositViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/7/24.
//

import Foundation

@Observable class PaymentMethodCashDepositViewModel: PaymentMethodCashDepositViewModelProtocol {
	var paymentMethodModel: PaymentMethodModel

	var expanded = true
    var saveLoading: Bool = false
	var didSaveAction: Bool = false
    var changePaymentMethodLoading: Bool = false
	var showChangePaymentMethodConfirmModal: Bool = false

    var disabled: Bool {
        return saveLoading || changePaymentMethodLoading
    }
    
    var editable: Bool {
        return paymentMethodModel.dependents.count > 0
    }
    
    var showChangePaymentMethod: Bool {
		return paymentMethodModel.paymentDetails.selectedPaymentMethodType == .cash
    }
    
    var saveable: Bool {
        return paymentMethodModel.paymentDetails.selectedPaymentMethodType == nil || (paymentMethodModel.paymentDetails.selectedPaymentMethodType == .cash && editable)
    }
    
    var imageURL: URL? {
        return URL(string: paymentMethodModel.cashDepositPages.reviewPage.imageURL)
    }
    
    var title: String {
        return paymentMethodModel.cashDepositPages.reviewPage.title
    }
    
    var description: String {
        return paymentMethodModel.cashDepositPages.reviewPage.description
    }
    
    var shouldShowDependentPicker: Bool {
        return paymentMethodModel.dependents.count > 0
    }

	var repository: PaymentMethodRepositoryProtocol

	init(paymentMethodModel: PaymentMethodModel, repository: PaymentMethodRepositoryProtocol) {
        self.paymentMethodModel = paymentMethodModel
		self.repository = repository
    }
    
    func save() {
        saveLoading = true
        Task {
			let success = await repository.save(paymentMethodModel: paymentMethodModel, paymentType: .cash)
            DispatchQueue.main.async { [weak self] in
                self?.saveLoading = false
				self?.didSaveAction = true
            }
        }
    }

	func tappedChangePaymentMethod() {
		showChangePaymentMethodConfirmModal = true
	}

    func confirmChangePaymentMethod() {
        changePaymentMethodLoading = true
        Task {
			let success = await repository.delete(paymentMethodModel: paymentMethodModel, paymentType: .cash)
            DispatchQueue.main.async { [weak self] in
                self?.changePaymentMethodLoading = false
				self?.didSaveAction = true
            }
        }
    }

}
