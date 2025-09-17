//
//  ViewCreditCardViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/15/24.
//

import Foundation

protocol ViewCreditCardViewModelProtocol {
	var showDeleteSheet: Bool { get set }
	var expanded: Bool { get set }

	var saveLoading: Bool { get set }
	var changePaymentMethodLoading: Bool { get set }

	var paymentMethodModel: PaymentMethodModel { get set }

	var imageURL: URL? { get }

	var shouldDismiss: Bool { get set }
	var name: String { get set }
	var cardNumber: String { get set }
	var expiryMonth: String { get set }
	var expiryYear: String { get set }
	var zipcode: String { get set }

	var disabled: Bool { get }
	var editable: Bool { get }
	var saveable: Bool { get }
	var showChangePaymentMethod: Bool { get }

	var deletePaymentMethodUseCase: DeletePaymentMethodUseCase { get }

	func save()
	func tappedChangePaymentMethod()
	func dismiss()
}

@Observable class ViewCreditCardViewModel: ViewCreditCardViewModelProtocol {
    var showDeleteSheet = false
    var expanded = true
    
    var saveLoading: Bool = false
    var changePaymentMethodLoading: Bool = false

    var paymentMethodModel: PaymentMethodModel
    private var cardDetails: CreditCardDetails?

    var imageURL: URL? {
        return URL(string: paymentMethodModel.cashDepositPages.reviewPage.imageURL)
    }
    
    var shouldDismiss: Bool = false
    var name = ""
    var cardNumber = ""
    var expiryMonth = ""
    var expiryYear = ""
	var zipcode = ""

    var disabled: Bool {
        return saveLoading || changePaymentMethodLoading
    }
    
    var editable: Bool {
        return paymentMethodModel.dependents.count > 0
    }
    
    var saveable: Bool {
        return paymentMethodModel.paymentDetails.selectedPaymentMethodType == nil || (paymentMethodModel.paymentDetails.selectedPaymentMethodType == .creditCard && editable)
    }
    
    var showChangePaymentMethod: Bool {
        return paymentMethodModel.paymentDetails.selectedPaymentMethodType == .creditCard
    }

    var savePaymentMethodUseCase: SavePaymentMethodUseCase
    var deletePaymentMethodUseCase: DeletePaymentMethodUseCase

    init(paymentMethodModel: PaymentMethodModel,
         cardDetails: CreditCardDetails?,
         savePaymentMethodUseCase: SavePaymentMethodUseCase,
         deletePaymentMethodUseCase: DeletePaymentMethodUseCase) {
        self.paymentMethodModel = paymentMethodModel
        self.cardDetails = cardDetails
        self.savePaymentMethodUseCase = savePaymentMethodUseCase
        self.deletePaymentMethodUseCase = deletePaymentMethodUseCase
        configureCardFields()
    }
    
    func save() {
        saveLoading = true
        Task {
            let _ = await savePaymentMethodUseCase.execute(paymentMethodModel: paymentMethodModel,
                                                                 paymentType: .creditCard)
            DispatchQueue.main.async { [weak self] in
                self?.saveLoading = false
                self?.shouldDismiss = true
            }
        }
    }
    
    func tappedChangePaymentMethod() {
        changePaymentMethodLoading = true
        Task {
			_ = await deletePaymentMethodUseCase.execute(paymentMethodModel: paymentMethodModel,
                                                                   paymentType: .creditCard)
            DispatchQueue.main.async { [weak self] in
                self?.changePaymentMethodLoading = false
                self?.shouldDismiss = true
            }
        }
    }
    
    func dismiss() {
        shouldDismiss = true
    }

    private func configureCardFields() {
        if let cardDetails = cardDetails {
            name = ""
            cardNumber = cardDetails.maskedCardNumber
            expiryMonth = ""
            expiryYear = ""
        } else {
            name = paymentMethodModel.paymentDetails.cardDetails.first?.name ?? ""
            cardNumber = paymentMethodModel.paymentDetails.cardDetails.first?.cardMaskedNo ?? ""
            expiryMonth = paymentMethodModel.paymentDetails.cardDetails.first?.cardExpiryMonth ?? ""
            expiryYear =  paymentMethodModel.paymentDetails.cardDetails.first?.cardExpiryYear ?? ""
			zipcode = paymentMethodModel.paymentDetails.cardDetails.first?.zipcode ?? ""
        }
    }
}
