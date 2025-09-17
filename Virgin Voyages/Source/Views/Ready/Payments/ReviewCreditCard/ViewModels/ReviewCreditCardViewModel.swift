//
//  ReviewCreditCardViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/4/24.
//

import Foundation

@Observable class ReviewCreditCardViewModel {
	var showDeleteSheet = false
	var expanded = true
    
    var saveLoading: Bool = false
    var changePaymentMethodLoading: Bool = false

	var paymentMethodModel: PaymentMethodModel
    var cardDetails: CreditCardDetails?

    var imageURL: URL? {
        return URL(string: paymentMethodModel.cashDepositPages.reviewPage.imageURL)
    }
    
    var shouldDismiss: Bool = false
	var name = ""
	var cardNumber = ""
	var expiryMonth = ""
	var expiryYear = ""
    
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
		return paymentMethodModel.paymentDetails.selectedPaymentMethodType == .cash
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
			let success = await savePaymentMethodUseCase.execute(paymentMethodModel: paymentMethodModel,
                                                                 paymentType: .creditCard)
            DispatchQueue.main.async { [weak self] in
                self?.saveLoading = false
                self?.shouldDismiss = true
            }
        }
    }
    
    func changePaymentMethod() {
        changePaymentMethodLoading = true
        Task {
            let success = await deletePaymentMethodUseCase.execute(paymentMethodModel: paymentMethodModel,
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
            name = "\(cardDetails.firstName) \(cardDetails.lastName)"
            cardNumber = cardDetails.maskedCardNumber
            expiryMonth = String(cardDetails.cardExpiry.suffix(2))
            expiryYear = String(cardDetails.cardExpiry.prefix(2))
        } else {
            name = paymentMethodModel.savedCards.first?.name ?? ""
			cardNumber = paymentMethodModel.savedCards.first?.maskedNumber ?? ""
			expiryMonth = paymentMethodModel.savedCards.first?.expiryMonth ?? "**"
			expiryYear =  paymentMethodModel.savedCards.first?.expiryYear ?? "**"
        }
	}
}
