//
//  AddOnsListScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 25.9.24.
//

import Foundation

@Observable class AddOnsListScreenViewModel: BaseViewModelV2, AddOnsListScreenViewModelProtocol {

    // MARK: - Properties
    var addOnsUseCase: GetAddOnsUseCase
    var addOns: [AddOn]
    var addOnsText: String
    var addOnsSubtitle: String
    var viewAddOnsText: String
    var screenState: ScreenState
	
	private var bookingEventsNotificationService: BookingEventsNotificationService
	private var listenerKey: String {
		return String(describing: type(of: self))
	}

    private var selectedAddOnCode: String?
    
    // MARK: - Init
    init(selectedAddOnCode: String? = nil,  addOnsUseCase: GetAddOnsUseCase, addons: [AddOn], addonsText: String = "", addonsSubtitle: String = "", viewAddOnsText: String = "", screenState: ScreenState = .loading, bookingEventsNotificationService: BookingEventsNotificationService = .shared) {
        self.addOnsUseCase = addOnsUseCase
        self.addOns = addons
        self.addOnsText = addonsText
        self.addOnsSubtitle = addonsSubtitle
        self.viewAddOnsText = viewAddOnsText
        self.screenState = screenState
		self.bookingEventsNotificationService = bookingEventsNotificationService
        self.selectedAddOnCode = selectedAddOnCode
        
		super.init()
		self.startObservingEvents()
    }

    // MARK: - OnAppear
    func onAppear() {
        self.screenState = .loading
		Task {
			let result = await addOnsUseCase.getAddOns()
			await MainActor.run {
				switch result {
				case .success(let details):
					updateAddOns(details)
				case .failure:
					self.screenState = .error
					break
				}
			}
		}
    }

	func onReAppear() {
		Task {
			let result = await addOnsUseCase.getAddOns()
			switch result {
			case .success(let details):
				updateAddOns(details)
			case .failure:
				break
			}
		}
	}

	private func updateAddOns(_ details: AddOnDetails) {
		self.addOns = details.addOns
		self.addOnsSubtitle = details.addOnsSubtitle
		self.addOnsText = details.addOnsText
		self.viewAddOnsText = details.viewAddOnsText
		self.screenState = .content
        self.checkAutoSelectAddon()
	}

	func onViewAddOnsTapped() {
		navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAddonsScreenCommand())
	}
    
    private func checkAutoSelectAddon() {
        if let selectedAddOnCode {
            if let selectedAddon = self.addOns.first(where: { $0.code == selectedAddOnCode }) {
                self.selectedAddOnCode = nil
                self.autoOpenAddOn(addOn: selectedAddon)
            }
        }
    }
    
    private func autoOpenAddOn(addOn: AddOn) {
        navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenAddonDetailsCommand(addOn: addOn))
    }
}


// MARK: - Event Handling
extension AddOnsListScreenViewModel {

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
				onAppear()
			}
		default: break
		}
	}
}
