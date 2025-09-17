//
//  SetPinLandingScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 17.7.25.
//

import Observation

@Observable class SetPinLandingScreenViewModel: BaseViewModel, SetPinLandingScreenViewModelProtocol {

	private let localizationManager: LocalizationManagerProtocol
	private var listenerKey = "SetPinLandingScreenViewModel"
	private let setPinEventNotificationService: SetPinEventNotificationService

	var labels: SetPinLandingScreen.Labels {
		.init(title: localizationManager.getString(for: .setPinTitle),
			  subtitle: localizationManager.getString(for: .setPinSubtitle),
			  changePinButton: localizationManager.getString(for: .changePinButton),
			  successMessageTitle: localizationManager.getString(for: .casinoEditSuccessHeading),
			  successMessageBody: localizationManager.getString(for: .casinoEditSuccessBody)
		)
	}

	var showSuccessMessage: Bool = false

	init(localizationManager: LocalizationManagerProtocol = LocalizationManager.shared,
		 setPinEventNotificationService: SetPinEventNotificationService = SetPinEventNotificationService()) {
		self.localizationManager = localizationManager
		self.setPinEventNotificationService = setPinEventNotificationService
		super.init()
		self.startObservingEvents()
	}

	deinit {
		resetSuccessMessage()
		stopObservingEvents()
	}
	
	func onBackButtonTap() {
		resetSuccessMessage()
		navigationCoordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateBack()
	}

	func onChangePinButtonTap() {
		resetSuccessMessage()
		navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenSetPinCommand())
	}

	private func resetSuccessMessage() {
		showSuccessMessage = false
	}

}

// MARK: - Event Handling
extension SetPinLandingScreenViewModel {
	func startObservingEvents() {
		setPinEventNotificationService.listen(key: listenerKey) { [weak self] event in
			guard let self else { return }
			self.handleEvent(event)
		}
	}

	func stopObservingEvents() {
		setPinEventNotificationService.stopListening(key: listenerKey)
	}

	func handleEvent(_ event: SetPinNotification) {
		switch event {
		case .error:
			break
		case .success:
			refreshLandingScreen()
		}
	}

	private func refreshLandingScreen() {
		showSuccessMessage = true
	}
}
