//
//  ShoreThingDetailsScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 15.5.25.
//

import SwiftUI

@Observable class ShoreThingDetailsScreenViewModel: BaseViewModel, ShoreThingDetailsScreenViewModelProtocol {
	private let getShoreThingItemUseCase: GetShoreThingItemUseCaseProtocol
	private var bookingEventsNotificationService: BookingEventsNotificationService
	private var listenerKey = "ShoreThingDetailsScreenViewModel"
	
	var screenState: ScreenState = .loading
	var shoreThingItem: ShoreThingItem
	var bookingSheetViewModel: BookingSheetViewModel? = nil
	var showPreVoyageBookingStopped: Bool = false
	var showBookEventSheet: Bool = false
	
	init(shoreThingItem: ShoreThingItem,
		 getShoreThingItemUseCase: GetShoreThingItemUseCaseProtocol = GetShoreThingItemUseCase(),
		 bookingEventsNotificationService: BookingEventsNotificationService = .shared
	) {
		self.shoreThingItem = shoreThingItem
		
		self.getShoreThingItemUseCase = getShoreThingItemUseCase
		self.bookingEventsNotificationService = bookingEventsNotificationService
		
		super.init()
		self.startObservingEvents()
	}
	
	func onAppear() {
		screenState = .content
	}
	
	func onRefresh() {
		Task {
			await loadShoreThingDetails(slotId: shoreThingItem.selectedSlot?.id ?? "")
		}
	}
	
	private func loadShoreThingDetails(slotId: String) async {
		if let result = await executeUseCase({
			try await self.getShoreThingItemUseCase.execute(id: self.shoreThingItem.id,
															slotId: slotId,
															portCode: self.shoreThingItem.portCode,
															portStartDate: self.shoreThingItem.portStartDate,
															portEndDate: self.shoreThingItem.portEndDate)
		}) {
			await executeOnMain({
				self.shoreThingItem = result
				self.screenState = .content
			})
		} else {
			await executeOnMain({
				self.screenState = .error
			})
		}
	}
	
	@MainActor func onPurchaseTapped() {
		if shoreThingItem.isPreVoyageBookingStopped {
			showPreVoyageBookingStopped = true
			return
		}
		
        bookingSheetViewModel = BookingSheetViewModel(title: shoreThingItem.name,
													  activityCode: shoreThingItem.id,
													  bookableType: .shoreExcursion,
													  price: shoreThingItem.price,
													  currencyCode: shoreThingItem.currencyCode,
													  categoryCode: shoreThingItem.categoryCode,
													  slots: shoreThingItem.slots,
                                                      initialSlotId: shoreThingItem.selectedSlot?.id,
                                                      appointmentId: shoreThingItem.id,
													  locationString: shoreThingItem.location)
        
        self.navigationCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.setupPaths(paths: [.landing])
		showBookEventSheet = true
	}
	
	func onContactSupportTapped() {
		if let url = URL(string: "https://help.virginvoyages.com/helpportal/s/contactus") {
			UIApplication.shared.open(url)
		}
	}
    
    
	
	deinit {
		stopObservingEvents()
	}
    
    var ctaTitle: String {
        if let selectedSlot = shoreThingItem.selectedSlot?.status {
            return selectedSlot.titleForCTA
        }
        // Default
        return SlotStatus.available.titleForCTA
    }
    
    var isBookAvailable: Bool {
        if let status = shoreThingItem.selectedSlot?.status {
            switch status {
            case .available:
                return true
            default:
                return false
            }
        }
        // Default
        return true
    }
}

// MARK: - Event Handling
extension ShoreThingDetailsScreenViewModel {
	private func startObservingEvents() {
		bookingEventsNotificationService.listen(key: listenerKey) { [weak self] event in
			guard let self else { return }
			self.handleEvent(event)
		}
	}

	private func stopObservingEvents() {
		bookingEventsNotificationService.stopListening(key: listenerKey)
	}

	private func handleEvent(_ event: BookingEventNotification) {
		switch event {
		case .userDidMakeABooking(_, let activitySlotCode),
			 .userDidUpdateABooking(_, let activitySlotCode, _):
			Task {
				await loadShoreThingDetails(slotId: activitySlotCode)
			}
		default: break
		}
	}
}
