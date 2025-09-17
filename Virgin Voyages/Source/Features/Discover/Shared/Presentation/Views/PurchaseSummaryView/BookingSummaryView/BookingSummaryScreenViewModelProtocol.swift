//
//  BookingSummaryViewModelProtocol.swift
//  Virgin Voyages
//
//  Created by TX on 8.5.25.
//

import VVUIKit
import Foundation

protocol BookingSummaryScreenViewModelProtocol {

    // Screen states:
    var screenState: ScreenState { get set }
	var toolbarButtonStyle: ToolbarButtonStyle { get }
    var isRunningActivity: Bool { get }
    var payWithDifferentCardLoading: Bool { get set }
    var payWithExistingCardLoading: Bool { get set }
    var paymentDidSucceed: Bool { get set }
	var showPreviewMyAgendaSheet: Bool {get set}

    // Displaying properties
	var isShipside: Bool { get }
	var card: CardViewModel? { get }
	var headline: String { get }
	var name: String { get }
	var priceToPay: String { get }
    var priceStringWithCurrencySign: String? { get }
	var bookingForText: String { get }
	var isNonPaid: Bool { get }
    var date: String? { get }
	var bookableDate: Date { get }
    var bookableImageName: String? { get }
    var sailorsProfileImageUrl: [String]? { get }
    var paymentError: String? { get set }
	
    // Confirmation screen related properties
    var bookingConfirmationTitle: String { get }
	var bookingConfirmationSubheadline: String { get }
	var bookingConfirmationImageName: String { get }
    var bookingConfirmationSecondaryButtonTitle: String? { get }
    var location: String? { get }

    // Events
	func onAppear()
	func payWithExistingCard()
	func payWithOtherCard()
    func openTermsAndConditions()
	func onPreviewAgendaTapped()
	func onPreviewMyAgendaDismiss()
	func onViewInYourAgendaTapped()
    func openPrivacyPolicy()
}

