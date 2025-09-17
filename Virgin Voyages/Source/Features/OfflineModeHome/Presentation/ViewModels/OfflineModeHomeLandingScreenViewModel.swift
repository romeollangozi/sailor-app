//
//  OfflineModeHomeLandingScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/21/25.
//


import SwiftUI
import Foundation

@Observable class OfflineModeHomeLandingScreenViewModel: BaseViewModel, OfflineModeHomeLandingScreenViewModelProtocol {

	var navigationPath: NavigationPath {
		get {
			return navigationCoordinator.offlineModeLandingScreenCoordinator.navigationRouter.navigationPath
		}
		set {
			return navigationCoordinator.offlineModeLandingScreenCoordinator.navigationRouter.navigationPath = newValue
		}
	}

	var navigationRouter: NavigationRouter<OfflineModeHomeLandingNavigationRoute> {
		return navigationCoordinator.offlineModeLandingScreenCoordinator.navigationRouter
	}

	var shipTimeFormattedText: String? {
		return model?.shipTimeFormattedText
	}

	var allAboardTimeFormattedText: String? {
		return model?.allAboardTimeFormattedText
	}

	var lastUpdatedText: String? {
		return model?.lastUpdatedText
	}

	private var model: LoadOfflineModeHomeLandingUseCaseModel?

	private var loadOfflineModeHomeLandingUseCase: LoadOfflineModeHomeLandingUseCase

	init(
		loadOfflineModeHomeLandingUseCase: LoadOfflineModeHomeLandingUseCase = LoadOfflineModeHomeLandingUseCase()
	) {
		self.loadOfflineModeHomeLandingUseCase = loadOfflineModeHomeLandingUseCase
	}

	func onAppear() {
		Task { [weak self] in
			guard let self = self else { return }
			let result = await executeUseCase {
				await self.loadOfflineModeHomeLandingUseCase.execute()
			}

			if let result {
				await self.updateUI(with: result)
			}
		}
	}

	func navigateToAgenda() {
		navigationRouter.navigateTo(.agenda)
	}

	func navigateToLineUp() {
		navigationRouter.navigateTo(.eventLineUp)
	}

	@MainActor
	private func updateUI(with model: LoadOfflineModeHomeLandingUseCaseModel) {
		self.model = model
	}
}
