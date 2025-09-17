//
//  SetPinScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 17.7.25.
//

import Observation

@Observable class SetPinScreenViewModel: BaseViewModel, SetPinScreenViewModelProtocol {

	private let localizationManager: LocalizationManagerProtocol
	private let setPinEventNotificationService: SetPinEventNotificationServiceProtocol
	private let setPinUseCase: SetPinUseCaseProtocol
	private var pin: String?

	var isLoading: Bool = false
	var showError: Bool = false
	var isSaveButtonEnabled: Bool {
		return pin?.count == 4
	}

	var labels: SetPinScreen.Labels {
		.init(title: localizationManager.getString(for: .changePinTitle),
			  saveButtonTitle: localizationManager.getString(for: .savePinButton),
			  casinoEditErrorBody: localizationManager.getString(for: .casinoEditErrorBody),
			  casinoEditErrorHeading: localizationManager.getString(for: .casinoEditErrorHeading))
	}

	init(localizationManager: LocalizationManagerProtocol = LocalizationManager.shared,
		 setPinUseCase: SetPinUseCaseProtocol = SetPinUseCase(),
		 setPinEventNotificationService: SetPinEventNotificationServiceProtocol = SetPinEventNotificationService()) {

		self.localizationManager = localizationManager
		self.setPinUseCase = setPinUseCase
		self.setPinEventNotificationService = setPinEventNotificationService

	}

	private func notifyParentScreen() {
		setPinEventNotificationService.notify(.success)
	}

	func onBackButtonTap() {
		navigationCoordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateBack()
	}

	func onSetPinValue(pin: String) {
		self.pin = pin
	}

	func onChangePinButtonTap() {
		Task {
			await setPin()
		}
	}

	private func setPin() async {
		guard let pin = self.pin else { return }
		if let _ = await executeUseCase({ [self] in
			try await setPinUseCase.execute(pin: pin)
		}) {
			await executeOnMain({
				self.isLoading = false
				self.showError = false
				self.notifyParentScreen()
				self.navigationCoordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateBack()
			})
		} else {
			await executeOnMain({
				self.isLoading = false
				self.showError = true
			})
		}
	}
}
