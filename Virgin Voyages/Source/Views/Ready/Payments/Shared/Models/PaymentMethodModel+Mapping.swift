//
//  PaymentMethodModel+Mapping.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/11/24.
//

import Foundation

extension Endpoint.GetPaymentMethodTask.Response.Labels {
	func toModel() -> Labels {
		return Labels(expiry: expiry, cardNumber: cardNumber, zip: zip, cvv: cvv, name: name)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.Buttons {
	func toModel() -> Buttons {
		return Buttons(edit: edit)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.CashDepositPages {
	func toModel() -> CashDepositPages {
		return CashDepositPages(
			reviewPage: reviewPage.toModel(),
			introPage: introPage.toModel()
		)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.CashDepositPages.ReviewPage {
	func toModel() -> ReviewPage {
		return ReviewPage(confirmationQuestion: confirmationQuestion, imageURL: imageURL, title: title, description: description)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.CashDepositPages.IntroPage {
	func toModel() -> IntroPage {
		return IntroPage(title: title, description: description)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.DependentsSection {
	func toModel() -> DependentsSection {
		return DependentsSection(
			completedPaymentDependentDescription: completedPaymentDependentDescription,
			dependentTitle: dependentTitle,
			pendingPaymentDependentDescription: pendingPaymentDependentDescription
		)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.CreditCardPages {
	func toModel() -> CreditCardPages {
		return CreditCardPages(
			existingCardModal: existingCardModal.toModel(),
			deleteCardModal: deleteCardModal.toModel()
		)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.CreditCardPages.ExistingCardModal {
	func toModel() -> ExistingCardModal {
		return ExistingCardModal(confirmationQuestion: confirmationQuestion, title: title, description: description)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.CreditCardPages.DeleteCardModal {
	func toModel() -> DeleteCardModal {
		return DeleteCardModal(title: title, description: description)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.PaymentMethodSelectionPages {
	func toModel() -> PaymentMethodSelectionPages {
		return PaymentMethodSelectionPages(
			paymentInfoModal: paymentInfoModal.toModel(),
			question: question,
			imageURL: imageURL
		)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.PaymentMethodSelectionPages.PaymentInfoModal {
	func toModel() -> PaymentInfoModal {
		return PaymentInfoModal(okayMessageText: okayMessageText, imageURL: imageURL, title: title, description: description)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.PaymentDetails {
	func toModel() -> PaymentDetails {
		return PaymentDetails(
			partyMembers: partyMembers.map { $0.toModel() },
			selectedPaymentMethodType: PaymentMethodType(rawValue: selectedPaymentMethodCode),
			cardDetails: cardDetails.map { $0.toModel() }
		)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.PaymentDetails.PartyMember {
	func toModel() -> PartyMember {
		return PartyMember(
			reservationGuestId: reservationGuestId,
			name: name,
			imageURL: imageURL,
			genderCode: genderCode,
			isPaymentMethodAlreadySet: isPaymentMethodAlreadySet,
			isDependent: isDependent,
			selectedPaymentMethodType: PaymentMethodType(rawValue: selectedPaymentMethodCode)
		)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.PaymentDetails.CreditCard {
	func toModel() -> CreditCard {
		return CreditCard(
			cardMaskedNo: cardMaskedNo,
			cardType: cardType,
			cardExpiryMonth: cardExpiryMonth,
			cardExpiryYear: cardExpiryYear,
			paymentToken: paymentToken,
			name: name,
			zipcode: zipcode ?? ""
		)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.SomeoneElsePages {
	func toModel() -> SomeoneElsePages {
		return SomeoneElsePages(
			reviewPage: reviewPage.toModel(),
			introPage: introPage.toModel()
		)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.SomeoneElsePages.ReviewPage {
	func toModel() -> ReviewPage {
		return ReviewPage(confirmationQuestion: confirmationQuestion, imageURL: imageURL, title: title, description: description)
	}
}

extension Endpoint.GetPaymentMethodTask.Response.SomeoneElsePages.IntroPage {
	func toModel() -> IntroPage {
		return IntroPage(title: title, description: description)
	}
}
