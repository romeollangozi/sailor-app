//
//  PurchasePaymentViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/22/25.
//

import SwiftUI
import ApptentiveKit

@Observable class PurchasePaymentViewModel: BaseViewModelV2 {
	var inputModel: BookingSummaryInputModel
	var url: URL
	var bookingConfirmationSubheadline: String
	var bookingConfirmationTitle: String
	var paymentDidSucceed: Bool = false

	var shouldShowAgendaNavigation: Bool {
		return inputModel.bookableType != .addOns
	}

	init(inputModel: BookingSummaryInputModel, url: URL, bookingConfirmationTitle: String, bookingConfirmationSubheadline: String) {
		self.inputModel = inputModel
		self.url = url
		self.bookingConfirmationSubheadline = bookingConfirmationSubheadline
		self.bookingConfirmationTitle = bookingConfirmationTitle
	}

	func didAuthorizeCard() {
		paymentDidSucceed = true
		if inputModel.bookableType == .addOns {
			Apptentive.shared.engage(event: "addon_booking_complete")
		}
	}
	
	func navigateToAgenda() {
		guard let selectedDate = self.inputModel.slot?.startDateTime else { return }
		self.navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: selectedDate))
	}
}
