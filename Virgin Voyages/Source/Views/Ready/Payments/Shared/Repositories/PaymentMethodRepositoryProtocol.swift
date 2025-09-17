//
//  PaymentMethodsRepository.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/5/24.
//

import Foundation

protocol PaymentMethodRepositoryProtocol {
	func fetchPaymentMethodModel() async -> PaymentMethodModel?
	func saveCardOnFile(reservationGuestId: String, savedCard: SavedCard) async throws
	func save(paymentMethodModel: PaymentMethodModel, paymentType: PaymentMethodType) async -> Bool
	func delete(paymentMethodModel: PaymentMethodModel, paymentType: PaymentMethodType) async -> Bool
}

class PaymentMethodRepository: PaymentMethodRepositoryProtocol {
	private var authentication: Endpoint.SailorAuthentication?

	init(authentication: Endpoint.SailorAuthentication?) {
		self.authentication = authentication
	}

	func fetchPaymentMethodModel() async -> PaymentMethodModel? {
		guard let authentication = authentication else { return nil }

		let paymentMethod = try? await authentication.fetch(Endpoint.GetPaymentMethodTask(reservation: authentication.reservation))
		let modes = try? await authentication.fetch(Endpoint.GetLookupData()).referenceData.paymentModes
		let savedCards = try? await authentication.fetch(Endpoint.GetSavedCards())
		guard let paymentMethod = paymentMethod, let modes = modes, let savedCards = savedCards else {
			return nil
		}

		let paymentMethodModelBuilder = PaymentMethodModelBuilder(paymentMethod: paymentMethod,
																  modes: modes,
																  savedCards: savedCards)

		return paymentMethodModelBuilder.buildPaymentMethodModel()
	}

	func saveCardOnFile(reservationGuestId: String, savedCard: SavedCard) async throws {
		let saveCardBody = SaveCardBody(
			consumerId: reservationGuestId,
			consumerType: "DXPReservationGuestId",
			cardMaskedNo: savedCard.maskedNumber,
			cardType: savedCard.type,
			cardExpiryMonth: savedCard.expiryMonth,
			cardExpiryYear: savedCard.expiryYear,
			paymentToken: savedCard.paymentToken,
			zipcode: savedCard.zipcode,
			billToCity: savedCard.billToCity,
			billToFirstName: savedCard.billToFirstName,
			billToLastName: savedCard.billToLastName,
			billToLine1: savedCard.billToLine1,
			billToLine2: savedCard.billToLine2,
			billToState: savedCard.billToState,
			billToZipCode: savedCard.billToZipCode,
			shipToCity: savedCard.shipToCity,
			shipToFirstName: savedCard.shipToFirstName,
			shipToLastName: savedCard.shipToLastName,
			shipToLine1: savedCard.shipToLine1,
			shipToLine2: savedCard.shipToLine2,
			shipToState: savedCard.shipToState,
			shipToZipCode: savedCard.shipToZipCode,
			receiptReference: savedCard.receiptReference,
			tokenProvider: savedCard.tokenProvider
		)
		try await NetworkService.create().saveCard(body: saveCardBody)
	}

	func save(paymentMethodModel: PaymentMethodModel, paymentType: PaymentMethodType) async -> Bool {
		guard let authentication = authentication else { return false }

		do {
			let paymentToken = paymentMethodModel.savedCards.first?.paymentToken

			let partyMembers = paymentMethodModel.dependents.toDTOs()
			try await authentication.save(selectedPaymentMethodCode: paymentType.rawValue,
										  paymentToken: paymentToken ?? "",
										  partyMembers: partyMembers)
			return true
		} catch {
			return false
		}
	}

	func delete(paymentMethodModel: PaymentMethodModel, paymentType: PaymentMethodType) async -> Bool {
		guard let authentication = authentication else { return false }

		do {
			let paymentToken = paymentMethodModel.paymentDetails.cardDetails.first?.paymentToken
			let partyMembers = paymentMethodModel.dependents.toDTOs(isOnDelete: true)
			try await authentication.delete(selectedPaymentMethodCode: paymentType.rawValue,
											paymentToken: paymentToken ?? "",
											partyMembers: partyMembers)
			return true
		} catch {
			return false
		}
	}
}

extension Endpoint.SailorAuthentication {
	@discardableResult func save(selectedPaymentMethodCode: String,
								 paymentToken: String,
								 partyMembers: [Endpoint.UpdatePaymentMethodTask.Request.PartyMember]) async throws -> Endpoint.GetReadyToSail.UpdateTask{
		try await fetch(Endpoint.UpdatePaymentMethodTask(paymentMethodCode: selectedPaymentMethodCode,
														 isDeleted: false,
														 partyMembers: partyMembers,
														 reservation: reservation,
														 paymentToken: paymentToken))
	}

	@discardableResult func delete(selectedPaymentMethodCode: String,
								   paymentToken: String,
								   partyMembers: [Endpoint.UpdatePaymentMethodTask.Request.PartyMember]) async throws -> Endpoint.GetReadyToSail.UpdateTask? {

		return try await fetch(Endpoint.UpdatePaymentMethodTask(paymentMethodCode: selectedPaymentMethodCode,
																isDeleted: true,
																partyMembers: partyMembers,
																reservation: reservation,
																paymentToken: paymentToken))
	}

	@discardableResult func deletePaymentMethod() async throws -> Endpoint.GetReadyToSail.UpdateTask? {
		let payment = try await fetch(Endpoint.GetPaymentMethodTask(reservation: reservation))
		guard let code = payment.paymentDetails.selectedPaymentMethodCode.maybeNil else {
			return nil
		}

		let partyMembers: [Endpoint.UpdatePaymentMethodTask.Request.PartyMember] = payment.paymentDetails.partyMembers.map {
			.init(reservationGuestId: $0.reservationGuestId, isSelected: false, isDeleted: true)
		}

		return try await fetch(Endpoint.UpdatePaymentMethodTask(paymentMethodCode: code, isDeleted: true, partyMembers: partyMembers, reservation: reservation))
	}
}


extension Array where Element: Dependent {
	func toDTOs(isOnDelete: Bool = false) -> [Endpoint.UpdatePaymentMethodTask.Request.PartyMember] {
		return map {.init(reservationGuestId: $0.id, isSelected: $0.selected, isDeleted: isOnDelete ? $0.selected : false)}
	}
}

fileprivate class PaymentMethodModelBuilder {
	var paymentMethod: Endpoint.GetPaymentMethodTask.ResponseType
	var modes: [Endpoint.GetLookupData.Response.LookupData.PaymentMode]
	var savedCards: Endpoint.GetSavedCards.ResponseType

	init(paymentMethod: Endpoint.GetPaymentMethodTask.ResponseType,
		 modes: [Endpoint.GetLookupData.Response.LookupData.PaymentMode],
		 savedCards: Endpoint.GetSavedCards.ResponseType) {
		self.paymentMethod = paymentMethod
		self.modes = modes
		self.savedCards = savedCards
	}

	func buildPaymentMethodModel() -> PaymentMethodModel? {
		return PaymentMethodModel(buttons: paymentMethod.buttons.toModel(),
								  cashDepositPages: paymentMethod.cashDepositPages.toModel(),
								  updateURL: paymentMethod.updateURL,
								  dependentsSection: paymentMethod.dependentsSection.toModel(),
								  creditCardPages: paymentMethod.creditCardPages.toModel(),
								  paymentMethodSelectionPages: paymentMethod.paymentMethodSelectionPages.toModel(),
								  availablePaymentMethods: createAvailablePaymentMethods(),
								  paymentDetails: paymentMethod.paymentDetails.toModel(),
								  someoneElsePages: paymentMethod.someoneElsePages.toModel(),
								  dependents: createDependents(),
								  savedCards: savedCards.toModel())
	}

	func createAvailablePaymentMethods() -> [PaymentMethod] {
		var availablePaymentMethods = [PaymentMethod]()

		paymentMethod.paymentModes.forEach({ paymentMethodID in
			if let mode = modes.first(where: { $0.id == paymentMethodID }) {
				if let paymentMethodType = PaymentMethodType(rawValue: paymentMethodID) {
					let paymentMethod = PaymentMethod(name: mode.name, type: paymentMethodType)
					availablePaymentMethods.append(paymentMethod)
				}
			}
		})

		return availablePaymentMethods
	}

	func createDependents() -> [Dependent] {
		paymentMethod.paymentDetails.partyMembers.map {
			.init(id: $0.reservationGuestId, selected: $0.isDependent)
		}
	}
}

extension Array where Element == Endpoint.GetSavedCards.Response {
	func toModel() -> [SavedCard] {
		return map { $0.toModel() }
	}
}

extension Endpoint.GetSavedCards.Response {
	func toModel() -> SavedCard {
		return SavedCard(
			expiryYear: cardExpiryYear,
			receiptReference: receiptReference,
			zipcode: zipcode ?? "",
			paymentToken: paymentToken,
			maskedNumber: cardMaskedNo,
			billToCity: billToCity ?? "",
			billToLine1: billToLine1 ?? "",
			billToLine2: billToLine2 ?? "",
			shipToCity: shipToCity ?? "",
			shipToFirstName: shipToFirstName ?? "",
			shipToLastName: shipToLastName ?? "",
			name: name,
			billToState: billToState ?? "",
			type: cardType,
			billToFirstName: billToFirstName ?? "",
			billToLastName: billToLastName ?? "",
			billToZipCode: billToZipCode ?? "",
			shipToLine1: shipToLine1 ?? "",
			shipToLine2: shipToLine2 ?? "",
			tokenProvider: tokenProvider ?? "",
			shipToZipCode: shipToZipCode ?? "",
			expiryMonth: cardExpiryMonth ?? "",
			shipToState: shipToState ?? ""
		)
	}
}
