//
//  LocalizedMessages.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 25.10.24.
//
// LocalizationManager.swift

import Foundation

protocol LocalizationManagerProtocol {
	func getString(for key: LocalizedStringKey) -> String
	func getString(for key: LocalizedStringKey, with parameters: [String: String]) -> String
	func setCustomTranslations(_ messages: [String: String])
	func loadDefaults()
}

class LocalizationManager: LocalizationManagerProtocol {
	static let shared = LocalizationManager(language: "en")

	private var _language: String
	private var defaultMessages: [String: String] = [:]
	private var customMessages: [String: String] = [:]

	private init(language: String) {
		self._language = language
		self.defaultMessages = LocalizationManager.loadDefaultsFromFile(for: language)
	}

	func setCustomTranslations(_ messages: [String: String]) {
		self.customMessages = messages
	}

	func loadDefaults() {
		self.customMessages = [:]
	}

	func getString(for key: LocalizedStringKey) -> String {
		return customMessages[key.key] ?? defaultMessages[key.key] ?? ""
	}

	func getString(for key: LocalizedStringKey, with parameters: [String: String]) -> String {
		let template = getString(for: key)
		return parameters.reduce(template) { result, entry in
			result.replacingOccurrences(of: "{\(entry.key)}", with: entry.value)
		}
	}

	private static func loadDefaultsFromFile(for language: String) -> [String: String] {
		guard let url = Bundle.main.url(forResource: "default_translations_\(language)", withExtension: "json") else {
			print("LocalizationManager - Error loading default translations JSON file. - Error: Files not found")
			return [:]
		}
		do {
			let data = try Data(contentsOf: url)
			let translations = try JSONDecoder().decode([String: String].self, from: data)
			return translations
		  } catch {
			  print("LocalizationManager - Error loading default translations JSON file. - Error \(error)")
			  return [:]
		  }
	}
}

// MARK: LocalizedStringKeys

// Enum to be used when we update the dictionary from the CMS API to access all of the known keys.
enum LocalizedStringKey {
	case messengerScreenTitle
	case preSailStatesNotificationsTitle
	case messengerEmptyWelcomeStatePreCruise
	case messengerEmptyWelcomeStateOnboard
	case preSailStatesNotificationsDescription
	case preSailStatesNoUnreadNotificationsNone
	case preSailStatesUnreadNotificationsMultiple
	case messengerContactAFriendButtonLabel
	case preSailStatesMessengerNotificationsNone
	case messengerContactsEmptyState
	case messengerContactListText
	case messengerYourCodeText
	case messengerScanCodeText
	case messengerSailorMatesText
	case messengerDirectoryText
	case messengerCabinmatesText
	case messengerLoadingText
	case messengerScaneHelpMeText
	case messengerPositionCameraText
	case messengerScaneHelpTitle
	case messengerScanHelpDescriptionText
	case messengerAllowAttendingText
	case messengerConnectedSailorText
	case messengerTryAgainText
	case messengerPleaseScanText
	case messengerOkText
	case messengerDoneText
	case messengerContactDeleteText

	case receiptViewEditButtonTitle
	case receiptViewCancelButtonTitle
	case receiptViewAllShoreThingsTitle
	case receiptViewDontForgetTitle
	case receiptViewPurchaseForTitle
	case receiptViewEnergyLevelTitle
	case receiptViewDurationTitle
	case receiptViewPortOfCallTitle
	case receiptViewTypeTitle

	case cancelBookingCannotCancelCloseToStartTime
	case cancelBookingOkGotIt
	case cancelBookingCancelForYourselfOrGroup
	case cancelBookingJustForMe
	case cancelBookingForTheWholeGroup
	case cancelBookingPleaseConfirmProceed
	case cancelBookingDoubleCheckNoSlip
	case cancelBookingChangedMyMind
	case cancelBookingConfirmCancellation
	case cancelBookingYesCancel
	case cancelBookingBookingCancelled
	case cancelBookingCancellation
	case movingBookingsAndBags
	case bookingsReopenOnBoard
	case gotIt
	case bookingClosed
	case bookedTickets
	case bookedTicket
	case myVoyageHeadline
	case myVoyageBody

	case shipTimeBottomSheetHeadline
	case shipTimeBottomSheetDescription

	case openingTimesUnavailable
	case closedText
	case bookingModalDescription
	case preVoyageBookingStoppedDescription
	case partySizeInfoDrawerBody
	case partySizeInfoDrawerHeading

	case folioCardOnFileText
	case folioCardExplainerText
	case folioBarTabExplainerText
	case folioBarTabInfoDrawerHeadline
	case folioBarTabInfoDrawerBody
	case walletFolioTotalText
	case shipEatsTaxText
	case globalGlobalShortStringsSubtotal

	case setPinTitle
	case setPinSubtitle
	case changePinButton
	case changePinTitle
	case savePinButton
	case casinoPinListingTitle
	case casinoPinListingDescription
	case casinoEditErrorHeading
	case casinoEditErrorBody
	case casinoEditSuccessHeading
	case casinoEditSuccessBody

	case emptyAgendaMessage
	case portDayLabel
	case yourPreviewAgendaText

	case voyageCancelledTitle
	case voyageCancelledDescription
	case okGotIt
	case contactSailorServiceButtonText

	case voyageNotFoundTitle
	case voyageNotFoundBody
    
    case apiErrorStateLogout
    case apiErrorStateWeAreSorryBody
    case apiErrorStateTroubleLoadingBody
    case globalContactSupportCta
    case apiErrorStateTroubleLoadingTitle
    case apiErrorStateWeAreSorryTitle
    
    case errorContentWentWrongHeadline
    case loginRegisterAgeFailMessage
    case errorContentEmailAddressInvalidError

    case deeplinkAddFriendTitle
    case deeplinkAddFriendAllowAttending
    case deeplinkAddFriendDescription
    case deeplinkAddFriendButton
	case contactsScanFoundFriendTitle
	case contactsScanQRCodeTitle
	case contactsScanQRCodeDescription
	case contactsScanQRCodeButton
	case contactsScanQRCodeFriendAlreadyAdded

	var key: String {
		switch self {
		case .messengerScreenTitle: return "global.messagesText"
		case .preSailStatesNotificationsTitle: return "preSailStates.notificationsTitle"
		case .messengerEmptyWelcomeStatePreCruise: return "messenger.emptyWelcomeState"
		case .messengerEmptyWelcomeStateOnboard: return "messenger.emptyWelcomeStateOnboard"
		case .preSailStatesNotificationsDescription: return "preSailStates.notificationsDescription"
		case .preSailStatesNoUnreadNotificationsNone: return "preSailStates.nnreadNotificationsNone"
		case .preSailStatesUnreadNotificationsMultiple: return "preSailStates.unreadNotificationsMultiple"
		case .messengerContactAFriendButtonLabel: return "messenger.contactAFriendButtonLabel"
		case .preSailStatesMessengerNotificationsNone: return "preSailStates.MessengerNotificationsNone"
		case .messengerContactsEmptyState: return "messenger.contacts.sailorEmptyState"
		case .messengerContactListText: return "messenger.contacts.listText"
		case .messengerYourCodeText: return "messenger.contacts.yourCodeText"
		case .messengerScanCodeText: return "messenger.contacts.scanCodeText"
		case .messengerSailorMatesText: return "messenger.contacts.sailorMatesText"
		case .messengerDirectoryText: return "messenger.contacts.directoryText"
		case .messengerCabinmatesText: return "messenger.contacts.cabinmatesText"
		case .messengerLoadingText: return "messenger.contacts.loadingText"
		case .messengerScaneHelpMeText: return "messenger.contacts.helpMeText"
		case .messengerPositionCameraText: return "messenger.contacts.positionCameraText"
		case .messengerScaneHelpTitle: return "messenger.contacts.helpTitle"
		case .messengerScanHelpDescriptionText: return "messenger.contacts.helpDescription"
		case .messengerConnectedSailorText: return "messenger.contacts.connectedSailorText"
		case .messengerTryAgainText: return "messenger.contacts.tryAgainText"
		case .messengerPleaseScanText: return "messenger.contacts.pleaseScanText"
		case .messengerOkText: return "messenger.contacts.okText"
		case .messengerDoneText: return "messenger.contacts.doneText"
		case .messengerContactDeleteText: return "messenger.buttonLabel"
		case .messengerAllowAttendingText: return "messenger.contacts.allowAttendingText"
		case .receiptViewEditButtonTitle: return "receiptView.editButtonTitle"
		case .receiptViewCancelButtonTitle: return "receiptView.cancelButtonTitle"
		case .receiptViewAllShoreThingsTitle: return "receiptView.allShoreThingsTitle"
		case .receiptViewDontForgetTitle: return "receiptView.dontForgetTitle"
		case .receiptViewPurchaseForTitle: return "receiptView.purchaseForTitle"
		case .receiptViewEnergyLevelTitle: return "receiptView.energyLevelTitle"
		case .receiptViewDurationTitle: return "receiptView.durationTitle"
		case .receiptViewPortOfCallTitle: return "receiptView.portOfCallTitle"
		case .receiptViewTypeTitle: return "receiptView.typeTitle"
		case .cancelBookingCannotCancelCloseToStartTime: return "booking.cannotCancelCloseToStartTime"
		case .cancelBookingOkGotIt: return "booking.okGotIt"
		case .cancelBookingCancelForYourselfOrGroup: return "booking.cancelForYourselfOrGroup"
		case .cancelBookingJustForMe: return "booking.justForMe"
		case .cancelBookingForTheWholeGroup: return "booking.forTheWholeGroup"
		case .cancelBookingPleaseConfirmProceed: return "booking.pleaseConfirmProceed"
		case .cancelBookingDoubleCheckNoSlip: return "booking.doubleCheckNoSlip"
		case .cancelBookingChangedMyMind: return "booking.changedMyMind"
		case .cancelBookingConfirmCancellation: return "booking.changedConfirmCancellation"
		case .cancelBookingYesCancel: return "booking.yesCancel"
		case .cancelBookingBookingCancelled: return "booking.bookingCancelled"
		case .cancelBookingCancellation: return "booking.cancellation"
		case .movingBookingsAndBags: return "preSailStates.movingBookingsAndBags"
		case .bookingsReopenOnBoard: return "preSailStates.bookingsReopenOnBoard"
		case .gotIt: return "preSailStates.gotIt"
		case .bookingClosed: return "global.pastEventBookingClosed"
		case .bookedTickets: return "discoverLineUp.bookedTickets"
		case .bookedTicket: return "discoverLineUp.bookedTicket"
		case .myVoyageHeadline: return "myVoyage.headline"
		case .myVoyageBody: return "myVoyage.body"
		case .shipTimeBottomSheetHeadline: return "shipboardHomescreen.shipTimeBottomSheetHeadline"
		case .shipTimeBottomSheetDescription: return "shipboardHomescreen.shipTimeBottomSheetDescription"
		case .openingTimesUnavailable: return "dining.openingTimesUnavailable"
		case .closedText: return "dining.closedText"
		case .bookingModalDescription: return "booking.modalDescription"
		case .preVoyageBookingStoppedDescription: return "dining.preVoyageBookingStoppedDescription"
		case .folioCardOnFileText: return "myWallet.cardOnFileText"
		case .folioCardExplainerText: return "myWallet.explainerText"
		case .folioBarTabExplainerText: return "myWallet.barTabExplainerText"
		case .folioBarTabInfoDrawerHeadline: return "myWallet.barTabInfoDrawerHeadline"
		case .folioBarTabInfoDrawerBody: return "myWallet.barTabInfoDrawerBody"
		case .walletFolioTotalText: return "walletFolio.totalText"
		case .shipEatsTaxText: return "shipEats.taxText"
		case .globalGlobalShortStringsSubtotal: return "global.globalShortStringsSubtotal"

		case .setPinTitle: return "accountVoyageSettings.casinoMainTitle"
		case .setPinSubtitle: return "accountVoyageSettings.casinoMainDescription"
		case .changePinButton: return "accountVoyageSettings.casinoMainChangePinLinkLabel"
		case .changePinTitle: return "accountVoyageSettings.casinoEditTitle"
		case .savePinButton: return "accountVoyageSettings.casinoEditSaveCta"
		case .casinoPinListingTitle: return "accountVoyageSettings.casinoPinListingTitle"
		case .casinoPinListingDescription: return "accountVoyageSettings.casinoPinListingDescription"
		case .casinoEditErrorHeading: return "accountVoyageSettings.casinoEditErrorHeading"
		case .casinoEditErrorBody: return "accountVoyageSettings.casinoEditErrorBody"
		case .casinoEditSuccessHeading : return "accountVoyageSettings.casinoEditSuccessHeading"
		case .casinoEditSuccessBody : return "accountVoyageSettings.casinoEditSuccessBody"
		case .partySizeInfoDrawerBody: return "dining.partySizeInfoDrawerBody"
		case .partySizeInfoDrawerHeading: return "dining.partySizeInfoDrawerHeading"
		case .emptyAgendaMessage: return "dining.emptyAgendaMessage"
		case .portDayLabel: return "dining.portDayLabel"
		case .yourPreviewAgendaText: return "dining.yourPreviewAgendaText"

		case .voyageCancelledTitle: return "apiErrorState.voyageCancelTitle"
		case .voyageCancelledDescription: return "errorContent.voyageCancelledDescription"
		case .okGotIt: return "loginRegister.okGotItCta"
		case .contactSailorServiceButtonText: return "messenger.contactSsButtonLabel"
		case .voyageNotFoundTitle: return "apiErrorState.voyageNotFoundTitle"
		case .voyageNotFoundBody: return "apiErrorState.voyageNotFoundBody"
			
		case .apiErrorStateLogout: return "apiErrorState.logout"
		case .apiErrorStateWeAreSorryBody: return "apiErrorState.weAreSorryBody"
		case .apiErrorStateTroubleLoadingBody: return "apiErrorState.troubleLoadingBody"
		case .globalContactSupportCta: return "global.contactSupportCta"
		case .apiErrorStateTroubleLoadingTitle: return "apiErrorState.troubleLoadingTitle"
		case .apiErrorStateWeAreSorryTitle: return "apiErrorState.weAreSorryTitle"

        case .errorContentWentWrongHeadline: return "errorContent.wentWrongHeadline"
        case .loginRegisterAgeFailMessage: return "loginRegister.ageFailMessage"
        case .errorContentEmailAddressInvalidError: return "errorContent.emailAddressInvalidError"

        case .deeplinkAddFriendTitle: return "deeplink.add_friend.title"
		case .deeplinkAddFriendAllowAttending: return "deeplink.add_friend.allow_attending"
		case .deeplinkAddFriendDescription: return "deeplink.add_friend.description"
		case .deeplinkAddFriendButton: return "deeplink.add_friend.button"

		case .contactsScanQRCodeTitle: return "contacts.scan_qr_code.title"
		case .contactsScanQRCodeButton: return "contacts.scan_qr_code.button"
		case .contactsScanQRCodeDescription: return "contacts.scan_qr_code.description"
		case .contactsScanFoundFriendTitle: return "deeplink.add_friend.scanTitle"
		case .contactsScanQRCodeFriendAlreadyAdded: return "contacts.scan_qr_code.friendAlreadyExist"
		}
	}
}
