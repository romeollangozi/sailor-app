//
//  AddonDetailsViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 26.9.24.
//

import Foundation
import SwiftUI

@Observable class AddOnDetailsViewModel: BaseViewModel, AddOnDetailsViewModelProtocol {
    
    // MARK: - Dependencies
    private let getAddOnsUseCase: GetAddOnsUseCaseProtocol
	private let getMySailorsUseCase: GetMySailorsUseCaseProtocol
    private var bookingEventsNotificationService: BookingEventsNotificationService
    private var listenerKey: String {
        return String(describing: type(of: self))
    }
    
    // MARK: - Public State
    
    var addOn: AddOn
    private let initialAddOnCode: String?
    var screenState: ScreenState = .loading
    var shouldReloadData: Bool = false
    var bookingSheetViewModel: BookingSheetViewModel? = nil
    var summaryInputModel: BookingSummaryInputModel? = nil
    
    var isShowingPurchaseSheet: Bool = false
    var isShowingBookingSummary: Bool = false
    
    // MARK: - Initialization
    
    init(addOn: AddOn,
         getAddOnsUseCase: GetAddOnsUseCaseProtocol = GetAddOnsUseCase(),
		 getMySailorsUseCase: GetMySailorsUseCaseProtocol = GetMySailorsUseCase(),
         bookingEventsNotificationService: BookingEventsNotificationService = .shared) {
        
        self.addOn = addOn
        self.initialAddOnCode = nil
        self.getAddOnsUseCase = getAddOnsUseCase
		self.getMySailorsUseCase = getMySailorsUseCase
        self.bookingEventsNotificationService = bookingEventsNotificationService
        
        super.init()
        self.startObservingEvents()
    }

    // Convenience init for code-only deep links
    init(addOnCode: String,
         getAddOnsUseCase: GetAddOnsUseCaseProtocol = GetAddOnsUseCase(),
         getMySailorsUseCase: GetMySailorsUseCaseProtocol = GetMySailorsUseCase(),
         bookingEventsNotificationService: BookingEventsNotificationService = .shared) {
        // Create a lightweight placeholder; real data loads on appear
        self.addOn = AddOn(code: addOnCode)
        self.initialAddOnCode = addOnCode
        self.getAddOnsUseCase = getAddOnsUseCase
        self.getMySailorsUseCase = getMySailorsUseCase
        self.bookingEventsNotificationService = bookingEventsNotificationService
        super.init()
        self.startObservingEvents()
    }
    
    // MARK: - Public Methods
    
	@MainActor func purchase() {
        if addOn.sellType == .perSailor {
            showBookingSheet()
        } else {
            openBookingSummary()
        }
    }
    
    func onAppear() {
        if (addOn.code ?? initialAddOnCode).value.isEmpty {
            self.screenState = .error
            return
        }
        // If we only have a code, load full details
        if self.addOn.name == nil || self.addOn.longDescription == nil {
            self.screenState = .loading
            Task {
                await updateAddonDetails()
            }
        } else {
            self.screenState = .content
        }
    }
    
    func onRefresh() {
        self.screenState = .content
    }
    
    func updateAddonDetails() async {
        let code = (addOn.code ?? initialAddOnCode).value
        let result = await getAddOnsUseCase.getAddOns(code: code)
        await MainActor.run {
            switch result {
            case .success(let details):
                if let addOn = details.addOns.first(where: { $0.code == code }) ?? details.addOns.first {
                    self.addOn = addOn
                }
                self.screenState = .content
            case .failure:
                self.screenState = .error
                break
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func openBookingSummary() {

		Task {
			var cabinMates: [SailorModel] = []
			if let result = await executeUseCase({
				try await self.getMySailorsUseCase.execute(useCache: false)
			}) {
				let allMySailors = result
				cabinMates = allMySailors.onlyCabinMates()
			}

			await executeOnMain {
				let summaryInput = BookingSummaryInputModel(
					appointmentId: "", // Provide actual value
					appointmentLinkId: nil, // Provide actual value if available
					slot: nil, // Provide actual value if available
					name: addOn.name ?? "",
					location: nil, // Provide actual value if available
					sailors: cabinMates, // Provide actual value
					previousBookedSailors: [], // Provide actual value
					totalPrice: addOn.totalAmount,
					currencyCode: addOn.currencyCode ?? "",
					activityCode: addOn.code ?? "",
					categoryCode: "", // Provide actual value
					bookableImageName: nil, // Provide actual value if available
					bookableType: .addOns,
					addonSellType: addOn.sellType, // Adjust if necessary
					categoryString: addOn.addonCategory,
					itemDescriptionString: addOn.subtitle
				)

				summaryInputModel = summaryInput
				self.navigationCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.goToRoot(animation: false)
				isShowingBookingSummary = true
			}
		}
    }
    
	@MainActor private func showBookingSheet() {
        bookingSheetViewModel = BookingSheetViewModel(title: addOn.name ?? "",
                                                      activityCode: addOn.code ?? "",
                                                      bookableType: .addOns,
                                                      price: addOn.amount,
                                                      currencyCode: addOn.currencyCode,
                                                      description: addOn.subtitle,
                                                      showAddNewSailorButton: false,
                                                      isSingleSelection: !(addOn.isPerSailorPurchase ?? true),
                                                      sailorSelectionStrategy: OnlyCabinMatesStrategy(),
                                                      categoryString: addOn.addonCategory,
                                                      eligibleGuestIds: addOn.eligibleGuestIds)
        self.navigationCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.setupPaths(paths: [.landing])
        isShowingPurchaseSheet = true
    }
    
    // MARK: - Deinitialization
    
    deinit {
        stopObservingEvents()
    }
}

// MARK: - Event Handling
extension AddOnDetailsViewModel {
    
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
        case .userDidMakeABooking, .userDidCancelABooking:
            Task {
                await updateAddonDetails()
            }
        default: break
        }
    }
}
