//
//  PurchasedAddonDetailsViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.10.24.
//

import SwiftUI

typealias ConfirmCancelationType = (confirmation: Bool, forSingleGuest: Bool, numberOfGuests: Int)

protocol PurchasedAddonDetailsViewModelProtocol {
    var addonDetailsUseCase: GetAddonDetailsUseCaseProtocol { get set }
    var cancelAddonUseCase: CancelAddonUseCaseProtocol { get set }
    var addonDetailsModel: AddonDetailsModel { get set }
    var screenState: ScreenState { get set }
    var showCancelationRefuse: Bool { get set }
    var showCancelationOptions: Bool { get set }
    var showConfirmCancelation: ConfirmCancelationType { get set }
    var showCanceledPurchase: Bool { get set}
    var addonCode: String { get set }
    var confirmCancellationHeading: String { get }
    func cancelAddon(singleGuest: Bool) async -> Result<Bool, VVDomainError>
    func onAppear() async
	func didCancelAddon()
    func prepearForCancellation(confirmation: Bool, forSingleGuest: Bool)
    var isRunningCanceling: Bool { get set }
}

@Observable class PurchasedAddonDetailsViewModel: BaseViewModel, PurchasedAddonDetailsViewModelProtocol {
    
    // MARK: - Properties
    var addonDetailsUseCase: any GetAddonDetailsUseCaseProtocol
    var cancelAddonUseCase: CancelAddonUseCaseProtocol
    var addonDetailsModel: AddonDetailsModel
    var screenState: ScreenState = .loading
    var showCancelationRefuse: Bool
    var showCancelationOptions: Bool
    var showConfirmCancelation: ConfirmCancelationType
    var showCanceledPurchase: Bool
    var addonCode: String
    var isRunningCanceling: Bool = false
	private var bookingEventsNotificationService: BookingEventsNotificationService
	private var listenerKey: String {
		return String(describing: type(of: self))
	}

    // MARK: - Init
	init(addonCode: String, addonDetailsUseCase: GetAddonDetailsUseCaseProtocol = GetAddonDetailsUseCase(), cancelAddonUseCase: CancelAddonUseCaseProtocol = CancelAddonUseCase(cancelAddonRepository: CancelAddonRepository()), showCancelationRefuse: Bool = false, showCancelationOptions: Bool = false, showConfirmCancelation: ConfirmCancelationType = (false, false, 1), showCanceledPurchase: Bool = false, addonDetailsModel: AddonDetailsModel = AddonDetailsModel(addon: AddOnModel(), cms: AddonCMSModel(), guestURL: []), bookingEventsNotificationService: BookingEventsNotificationService = .shared) {
        self.addonCode = addonCode
        self.showCancelationRefuse = showCancelationRefuse
        self.showCancelationOptions = showCancelationOptions
        self.showConfirmCancelation = showConfirmCancelation
        self.showCanceledPurchase = showCanceledPurchase
        self.cancelAddonUseCase = cancelAddonUseCase
        self.addonDetailsUseCase = addonDetailsUseCase
        self.addonDetailsModel = addonDetailsModel
		self.bookingEventsNotificationService = bookingEventsNotificationService

		super.init()
		self.startObservingEvents()
    }
    

    // MARK: - Cancel addon purchase
    func cancelAddon(singleGuest: Bool) async -> Result<Bool, VVDomainError> {
        let guestIds = singleGuest ? [addonDetailsModel.guestId].compactMap { $0 } : addonDetailsModel.guests
        return await cancelAddonUseCase.cancelAddon(guests: guestIds, code: addonCode, quantity: 1)
    }
    
    func onAppear() async {
        Task {
            self.screenState = .loading

			let addonDetails = await executeUseCase {
				return try await self.addonDetailsUseCase.execute(addonCode: self.addonCode)
			}

			guard let addonDetails = addonDetails else {
				return
			}

			self.addonDetailsModel = addonDetails
			self.screenState = .content
        }
    }

	override func handleError(_ error: any VVError) {
		if let error = error as? VVDomainError {
			if error == .genericError {
				self.screenState = .error
				return
			} else {
				self.screenState = .content
				return
			}
		}
		super.handleError(error)
	}

	func didCancelAddon() {
		bookingEventsNotificationService.publish(.userDidCancelABooking(appointmentLinkId: addonCode))
	}

    func prepearForCancellation(confirmation: Bool, forSingleGuest: Bool) {
        let guestIds = forSingleGuest ? [addonDetailsModel.guestId].compactMap { $0 } : addonDetailsModel.guests
        
        showConfirmCancelation = ConfirmCancelationType(confirmation: true, forSingleGuest: forSingleGuest, numberOfGuests: guestIds.count)
    }
    
    var confirmCancellationHeading: String {
        let numberOfGuests = showConfirmCancelation.numberOfGuests
        return self.addonDetailsModel.confirmationHeading.replacingPlaceholder("refundAmount", with: "\(addonDetailsModel.currencyCode.currencySign) \(self.addonDetailsModel.amount * Double(numberOfGuests))")
    }

	deinit {
		stopObservingEvents()
	}
}


// MARK: - Event Handling
extension PurchasedAddonDetailsViewModel {

	func stopObservingEvents() {
		bookingEventsNotificationService.stopListening(key: listenerKey)
	}

	func startObservingEvents() {
		bookingEventsNotificationService.listen(key: listenerKey) { [weak self] in
			guard let self else { return }
			self.handleEvent($0)
		}
	}

	func handleEvent(_ event: BookingEventNotification) {
		switch event {
		case .userDidCancelABooking:
			Task {
				await onAppear()
			}
		default: break
		}
	}
}
