//
//  OfflineModeMyAgendaScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/9/25.
//

import VVUIKit
import Foundation

@Observable class OfflineModeMyAgendaScreenViewModel: BaseViewModel, OfflineModeMyAgendaScreenViewModelProtocol {

	var shipTimeFormattedText: String? {
		return model?.shipTimeFormattedText
	}

	var allAboardTimeFormattedText: String? {
		return model?.allAboardTimeFormattedText
	}

	var lastUpdatedText: String? {
		return model?.lastUpdatedText
	}

	var eventCardModels: [OfflineModeMyAgendaEventCardModel] {
		guard let model else {
			return []
		}

		return model.myAgendaModel.bookings.compactMap({
			OfflineModeMyAgendaEventCardModel(
				name: $0.name,
				timePeriod: $0.timePeriod,
				location: $0.location
			)
		})
	}

	private var model: LoadOfflineModeMyAgendaUseCaseModel?

	private var loadOfflineModeMyAgendaUseCase: LoadOfflineModeMyAgendaUseCaseProtocol

	init(
		loadOfflineModeMyAgendaUseCase: LoadOfflineModeMyAgendaUseCaseProtocol = LoadOfflineModeMyAgendaUseCase()
	) {
		self.loadOfflineModeMyAgendaUseCase = loadOfflineModeMyAgendaUseCase
	}

	func onAppear() {
		Task { [weak self] in
			guard let self = self else { return }
			let result = await executeUseCase {
				await self.loadOfflineModeMyAgendaUseCase.execute()
			}

			if let result {
				await self.updateUI(with: result)
			}
		}
	}

	func navigateBack() {
		navigationCoordinator.offlineModeLandingScreenCoordinator.navigationRouter.navigateBack()
	}

	@MainActor
	private func updateUI(with model: LoadOfflineModeMyAgendaUseCaseModel) {
		self.model = model
	}
}
