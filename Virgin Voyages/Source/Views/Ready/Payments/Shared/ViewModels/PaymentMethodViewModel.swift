//
//  PaymentMethodViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/10/24.
//

import SwiftUI

extension PaymentMethodType {
	var step: PaymentMethodViewModel.Step {
		switch self {
		case .cash: .cash
		case .creditCard: .viewCard
		case .someoneElse: .someoneElse
		default: .start
		}
	}
}

extension Optional where Wrapped == PaymentMethodType {
	var step: PaymentMethodViewModel.Step {
		switch self {
		case .some(let paymentMethodType):
			return paymentMethodType.step
		case .none:
			return .start
		}
	}
}

@Observable class PaymentMethodViewModel: PaymentMethodViewModelProtocol {

	enum Step: String {
		case start
		case cash
		case addCard
		case reviewCard
		case someoneElse
        case viewCard
	}

	var step: Step
    var cardDetails: CreditCardDetails?

	var paymentMethodModel: PaymentMethodModel
	var repository: PaymentMethodRepositoryProtocol

	var imageURL: URL?
	var backgroundColor: Color
    var completionPercentage: Double

	init(imageURL: URL?,
		 backgroundColor: Color,
		 paymentMethodModel: PaymentMethodModel,
		 repository: PaymentMethodRepositoryProtocol,
         completionPercentage: Double) {
		self.imageURL = imageURL
		self.backgroundColor = backgroundColor
		self.paymentMethodModel = paymentMethodModel
		self.repository = repository
        self.completionPercentage = completionPercentage
        _step = paymentMethodModel.paymentDetails.selectedPaymentMethodType?.step ?? .start
	}
    
    var shouldShowReviewCreditCardModal: Bool = false
    var shouldShowFailedPayment: Bool = false
    var paymentFailedError: String = ""

	func selectedPaymentMethodAtIndex(_ index: Int) {
		let paymentMethodType = paymentMethodModel.availablePaymentMethods[index].type

		switch paymentMethodType {
		case .creditCard:
			navigateToCreditCard()
		case .cash:
			navigateToCash()
		case .someoneElse:
			navigateToSomeoneElse()
		}
	}

	func navigateToCreditCard() {
		if paymentMethodModel.paymentDetails.selectedPaymentMethodType == nil {
			shouldShowReviewCreditCardModal = paymentMethodModel.savedCards.count > 0
			if shouldShowReviewCreditCardModal == false {
				step = .addCard
			}
		} else {
			step = .viewCard
		}
	}

	private func navigateToCash() {
		step = .cash
	}

	private func navigateToSomeoneElse() {
		step = .someoneElse
	}

	var task: SailTask {
		.paymentMethod
	}

	var navigationMode: NavigationMode {

        if step != .start, paymentMethodModel.paymentDetails.selectedPaymentMethodType == nil {
			return .back
		}

		return .dismiss
	}
    
    func dismissReviewCreditCardModal() {
        shouldShowReviewCreditCardModal = false
    }

	func saveCard() {
		guard let currentSailor = CurrentSailorManager().getCurrentSailor() else {
			return
		}

		if let savedCard = self.paymentMethodModel.savedCards.first {
			Task {
				try? await repository.saveCardOnFile(reservationGuestId: currentSailor.reservationGuestId,
										  savedCard: savedCard)
				await navigateToReviewCard()
			}
		}
	}

	@MainActor
    func navigateToReviewCard() {
        shouldShowReviewCreditCardModal = false
        step = .reviewCard
    }
    
    func navigateToAddCard() {
        shouldShowReviewCreditCardModal = false
        step = .addCard
    }

	func discardChanges() {
		step = .start
	}

	func startInterview() {

	}

	func startOver() {
		step = .start
	}

	func back() {
		step = .start
	}

	func reload(_ sailor: Endpoint.SailorAuthentication) async throws {
	}
}
