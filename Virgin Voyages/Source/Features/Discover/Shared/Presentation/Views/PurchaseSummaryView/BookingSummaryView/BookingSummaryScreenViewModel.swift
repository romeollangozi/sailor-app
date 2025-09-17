//
//  BookingSummaryScreenViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 8.5.25.
//

import VVUIKit
import Foundation
import ApptentiveKit

struct BookingSummaryInputModel: Hashable {
    let appointmentId: String
    let appointmentLinkId: String?
    let slot: Slot?
    let name: String
    let location: String?
    let sailors: [SailorModel]
    let previousBookedSailors: [SailorModel]
    let totalPrice: Double?
    let currencyCode: String
    let activityCode: String
    let categoryCode: String
    let bookableImageName: String?
    let bookableType: BookableType
	let addonSellType: AddOnSellType?
    let categoryString: String?
	let itemDescriptionString: String?
    
    var priceForBookingActivity: Double {
        totalPrice ?? 0
    }
}

@Observable
class BookingSummaryScreenViewModel: BaseViewModel, BookingSummaryScreenViewModelProtocol {

    // MARK: - Dependencies
    private let appCoordinator: CoordinatorProtocol
    private let inputModel: BookingSummaryInputModel
    private var loadDataForBookingSummaryUseCase: LoadDataForBookingSummaryUseCaseProtocol
    private var bookActivityUseCase: BookActivityUseCaseProtocol
	private let itineraryDatesUseCase : GetItineraryDatesUseCaseProtocol
    private let payAddOnWithExistingCardUseCase: PayAddOnWithExistingCardUseCase
    private let getAddOnPaymentPageURLUseCase: GetAddOnPaymentPageURLUseCase

    // MARK: - Public State
    var screenState: ScreenState = .loading
	var showPreviewMyAgendaSheet: Bool = false
    var paymentError: String? = nil
    var paymentDidSucceed: Bool = false
    var payWithDifferentCardLoading: Bool = false
    var payWithExistingCardLoading: Bool = false

    var isRunningActivity: Bool {
        return payWithDifferentCardLoading || payWithExistingCardLoading
    }

	var toolbarButtonStyle: ToolbarButtonStyle {
		appCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.navigationPath.count > 0 ? .backAndCloseButton : .closeButton
	}

    // MARK: - Private State
    private var loadedModel: LoadDataForBookingSummaryUseCaseModel = .empty()
    private var savedCards: [CardViewModel] = []
    private var isRefundResponse: Bool = false

    // MARK: - Initialization
    init(inputModel: BookingSummaryInputModel,
         appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         loadDataForBookingSummaryUseCase: LoadDataForBookingSummaryUseCaseProtocol = LoadDataForBookingSummaryUseCase(),
         bookActivityUseCase: BookActivityUseCaseProtocol = BookActivityUseCase(),
         payAddOnWithExistingCardUseCase: PayAddOnWithExistingCardUseCase = PayAddOnWithExistingCardUseCase(),
         getAddOnPaymentPageURLUseCase: GetAddOnPaymentPageURLUseCase = GetAddOnPaymentPageURLUseCase(),
		 itineraryDatesUseCase : GetItineraryDatesUseCaseProtocol = GetItineraryDatesUseCase()
    ) {
        self.inputModel = inputModel
        self.appCoordinator = appCoordinator
        self.loadDataForBookingSummaryUseCase = loadDataForBookingSummaryUseCase
        self.bookActivityUseCase = bookActivityUseCase
		self.itineraryDatesUseCase = itineraryDatesUseCase

        self.payAddOnWithExistingCardUseCase = payAddOnWithExistingCardUseCase
        self.getAddOnPaymentPageURLUseCase = getAddOnPaymentPageURLUseCase
    }

    // MARK: - Public Methods
    func onAppear() {
        Task {
           await loadData()
        }
    }

    func payWithExistingCard() {
        isRefundResponse = false
        paymentError = nil
        payWithExistingCardLoading = true
        let payingWithExistingCard = true
        if inputModel.bookableType == .addOns {
            bookAddOn(withExistingCard: payingWithExistingCard)
        } else {
            bookActivity(payWithExistingCard: payingWithExistingCard)
        }
    }

    func payWithOtherCard() {
        isRefundResponse = false
        paymentError = nil
        payWithDifferentCardLoading = true
        let payingWithExistingCard = false
        if inputModel.bookableType == .addOns {
            bookAddOn(withExistingCard: payingWithExistingCard)
        } else {
            bookActivity(payWithExistingCard: payingWithExistingCard)
        }
    }
    
    func backButtonTapped() {
        self.appCoordinator.executeCommand(PurchaseSheetCoordinator.GoBackCommand())
    }
    
    func openTermsAndConditions() {
        self.appCoordinator.executeCommand(PurchaseSheetCoordinator.OpenTermsAndConditionsScreenCommand())
    }

    func openPrivacyPolicy() {
        self.appCoordinator.executeCommand(PurchaseSheetCoordinator.OpenPrivacyPolicyScreenCommand())
    }

	func onPreviewAgendaTapped() {
		showPreviewMyAgendaSheet = true
	}

	func onPreviewMyAgendaDismiss() {
		showPreviewMyAgendaSheet = false
	}

	func onViewInYourAgendaTapped() {
		guard let selectedDate = self.inputModel.slot?.startDateTime else { return }
		self.navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: selectedDate))
	}

    override func handleError(_ error: any VVError) {
		if let commonError = error as? VVDomainError {
			switch commonError {
			case .error(_, _):
				paymentError = "Oops! That didn't go as planned. Please try again!"
				return
			case .validationError(_):
				paymentError = "Oops! That didn't go as planned. Please try again!"
				return
			case .genericError:
				paymentError = "Oops! That didn't go as planned. Please try again!"
				return
			case .notFound:
				break
			case .unknownError:
				paymentError = "Oops! That didn't go as planned. Please try again!"
				return
			case .unauthorized:
				break
			}
		}
		super.handleError(error)
    }
    
    // MARK: - Private Methods
    func loadData() async {
        if let result = await executeUseCase ({
            try await self.loadDataForBookingSummaryUseCase.execute()
        }) {
            await executeOnMain {
                self.loadedModel = result
                self.loadSavedCards(savedCards: result.savedCards)
                self.screenState = .content
            }
        } else {
            self.screenState = .error
        }
    }
    
    private func loadSavedCards(savedCards: [SavedCard]) {
        self.savedCards = savedCards.map({
            CardViewModel(cardMaskedNo: $0.maskedNumber,
                          cardType: $0.type,
                          cardExpiryMonth: $0.expiryMonth,
                          cardExpiryYear: $0.expiryYear,
                          paymentToken: $0.paymentToken,
                          name: $0.name,
                          zipcode: $0.zipcode) })

    }
    
    private func bookActivity(payWithExistingCard: Bool) {
        Task {
            guard let slot = inputModel.slot else {
                self.payWithExistingCardLoading = false
                self.payWithDifferentCardLoading = false
                return
            }
            let input = BookActivityInputModel(activityCode: inputModel.activityCode,
                                               categoryCode: inputModel.categoryCode,
                                               currencyCode: inputModel.currencyCode,
                                               totalAmount: inputModel.priceForBookingActivity,
                                               slot: slot,
                                               sailors: inputModel.sailors,
                                               operationType: inputModel.appointmentLinkId != nil ? .edit : .book,
                                               bookableType: inputModel.bookableType,
                                               payWithExistingCard: payWithExistingCard,
                                               appointmentId: inputModel.appointmentId,
                                               appointmentLinkId: inputModel.appointmentLinkId,
                                               previousBookedSailors: inputModel.previousBookedSailors)

            let result: ActivityBookingServiceResult? = await executeUseCase {
                return try await self.bookActivityUseCase.execute(input: input)
            }
            await executeOnMain {
                self.handleBookingActivityResult(result)
            }
        }
        
    }

    private func handleBookingActivityResult(_ result: ActivityBookingServiceResult?) {
        self.payWithExistingCardLoading = false
        self.payWithDifferentCardLoading = false

        guard let result else {
            return
        }

        switch result {
        case .success(let result):
            if let isNoPaymentRequired = result.isNoPaymentRequired, isNoPaymentRequired {
                if let reason = result.reason, reason == .refundAutoDistributed {
                    isRefundResponse = true
                }
            }
            self.paymentDidSucceed = true
        case .requiresPaymentDetails(let paymentURL):
			let openPaymentPageCommand = PurchaseSheetCoordinator.OpenPaymentPageCommand(summaryInput: inputModel,
																						 appointmentId: inputModel.appointmentId,
                                                                                         paymentURL: paymentURL,
																						 bookingConfirmationSubheadline: bookingConfirmationSubheadline,
																						 bookingConfirmationTitle: bookingConfirmationTitle,
																						 activityCode: inputModel.activityCode,
																						 activitySlotCode: inputModel.slot?.id ?? "",
																						 isEditBooking: inputModel.appointmentLinkId != nil)
			self.appCoordinator.executeCommand(openPaymentPageCommand)
        }
    }

    // MARK: - Add On booking: Separate implementation
    private func bookAddOn(withExistingCard: Bool) {
        if withExistingCard {
            Task {
                if let result = await executeUseCase ({ [weak self] in
                    guard let self else { return false }
                    return try await self.payAddOnWithExistingCardUseCase.executeV2(
                        guestIds: self.inputModel.sailors.map { $0.guestId },
                        code: self.inputModel.activityCode,
                        currencyCode: self.inputModel.currencyCode,
                        amount: self.inputModel.priceForBookingActivity
                    )
                }) {
                    await executeOnMain {
                        self.payWithExistingCardLoading = false
                        self.paymentDidSucceed = result
						if result == true {
							Apptentive.shared.engage(event: "addon_booking_complete")
						}
                    }
                }
                await executeOnMain {
                    self.payWithExistingCardLoading = false
                }
            }
        } else {
            Task {
                if let paymentResult: GetAddOnPaymentPageURLUseCaseResult = await executeUseCase ({
                    return try await self.getAddOnPaymentPageURLUseCase.executeV2(
                        guestIds: self.inputModel.sailors.map { $0.guestId },
                        code: self.inputModel.activityCode,
                        currencyCode: self.inputModel.currencyCode,
                        amount: self.inputModel.priceForBookingActivity
                    )
                }) {
                    await executeOnMain {
						if case .paymentRequired(let paymentURL) = paymentResult {
							self.payWithDifferentCardLoading = false

							self.appCoordinator.executeCommand(PurchaseSheetCoordinator.OpenPaymentPageCommand(
								summaryInput: inputModel,
								appointmentId: inputModel.appointmentId,
								paymentURL: paymentURL,
								bookingConfirmationSubheadline: bookingConfirmationSubheadline,
								bookingConfirmationTitle: bookingConfirmationTitle,
								activityCode: inputModel.activityCode,
								activitySlotCode: inputModel.slot?.id ?? "",
								isEditBooking: inputModel.appointmentLinkId != nil))
						}
						else if case .paymentNotRequired = paymentResult {
							self.payWithDifferentCardLoading = false
							self.paymentDidSucceed = true
							Apptentive.shared.engage(event: "addon_booking_complete")
						}
                    }
                }
                await executeOnMain { [weak self] in
                    self?.payWithDifferentCardLoading = false
                }
            }
        }
    }
}

// MARK: - Booking Confirmation Members
/// These parameters are passed to the booking confirmation sheet.
extension BookingSummaryScreenViewModel {
    var bookingConfirmationImageName: String {
        isNonPaid ? "NonTicketedCancelationConfirmed" : "CancelationConfirmed"
    }

    var bookingConfirmationTitle: String {
		switch inputModel.bookableType{
		case .addOns:
			return "Purchased"
		default:
			return isNonPaid ? "Added to your Agenda" : "Booked"
		}
    }

    var bookingConfirmationSubheadline: String {
        var refoundText = ""
        if isRefundResponse {
            refoundText = "\n\n" + "We have used pending refunds in your account to make this purchase. If you have any queries please contact Sailor Services"
        }
        
        return "\(name), \(dateFormattedString ?? "")" + refoundText
    }

    var bookingConfirmationSecondaryButtonTitle: String? {
		switch inputModel.bookableType {
		case .addOns: return nil
		default: return "View in your Agenda"
		}
    }
}

// MARK: - Use Case Loaded Data Dependency
extension BookingSummaryScreenViewModel {
    var card: CardViewModel? {
        return savedCards.first
    }

    var isShipside: Bool {
        loadedModel.isShipSide
    }
}

// MARK: - Input Dependency
extension BookingSummaryScreenViewModel {
    
    var priceToPay: String {
        inputModel.priceForBookingActivity.toCurrency()
    }
    
    var priceStringWithCurrencySign: String? {
        let amount = inputModel.priceForBookingActivity
        let currencyCode = inputModel.currencyCode
        
        guard !inputModel.sailors.isEmpty else {
            return nil
        }
        return "\(currencyCode.currencySign) \(amount.toCurrency())"
    }

    var isNonPaid: Bool {
        (inputModel.totalPrice ?? 0) == 0
    }

    var headline: String {
		if let description = inputModel.itemDescriptionString {
			return description
		}
		
        guard let slot = inputModel.slot else { return "" }
        let activityDate = slot.startDateTime
        // TODO: not same for different types
        return activityDate.shortWeekdayFullMonthDayTime()
    }
    
    var location: String? {
        inputModel.location
    }
    
    var name: String {
        inputModel.name
    }
    
    var bookingForText: String {
		if inputModel.bookableType == .addOns {
			if let sellType = inputModel.addonSellType, sellType == .perCabin {
				return "Purchased for all sailors in your cabin"
			}
		}
        let guestCount = inputModel.sailors.count
        let guestName = inputModel.sailors.first?.name ?? ""
        let action = inputModel.bookableType == .addOns ? "Purchasing for" : "Booking for"
        return guestCount > 1 ? "\(action) \(guestCount) sailor".pluralized(for: guestCount) : "\(action) \(guestName)"
    }
    
    var dateFormattedString: String? {
        
        switch inputModel.bookableType {
        
        case .shoreExcursion, .entertainment:
            guard let slot = inputModel.slot else { return "" }
            return slot.startDateTime.dayAndTimeFormattedString()
        case .treatment:
            guard let slot = inputModel.slot else { return "" }
            return slot.dayName + ", " + slot.timeText
        case .addOns:
            return nil
        case .eatery:
            // TODO: To be implemented when we include eateries into the Booking Sheet Flow
            return nil
        case .undefined:
            return nil
        }
    }

    var sailorsProfileImageUrl: [String]? {
        inputModel.sailors.compactMap { $0.profileImageUrl }
    }
    
    var bookableImageName: String? {
        inputModel.bookableImageName
    }
    
    var date: String?{
        guard let slot = inputModel.slot else { return "" }
        return slot.startDateTime.toDayMonthDayTime()
    }

	var bookableDate: Date {
		guard let slot = inputModel.slot else { return Date() }
		return slot.startDateTime
	}
}
