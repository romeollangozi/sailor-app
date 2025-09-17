//
//  OfflineModeLineUpScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/16/25.
//


import VVUIKit
import Foundation

@Observable class OfflineModeLineUpScreenViewModel: BaseViewModel, OfflineModeLineUpScreenViewModelProtocol {

	var lineUpHourEvents: [VVUIKit.OfflineModeLineUpHourEvents] {
		guard let model else { return [] }
		return model.lineUpModel.lineUpHours.compactMap({
			OfflineModeLineUpHourEvents(time: $0.time,
										events: $0.events.compactMap({
				VVUIKit.OfflineModeLineUpEvent(name: $0.name,
											   timePeriod: $0.timePeriod,
											   location: $0.location)
            }), mustSeeEvents: $0.mustSeeEvents.compactMap({
                VVUIKit.OfflineModeLineUpEvent(name: $0.name,
                                               timePeriod: $0.timePeriod,
                                               location: $0.location)
            }))
		})
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
    
    var firstUpcomingEventIndex: Int? {
        model?.lineUpModel.lineUpHours.firstIndex { lineUpHours in
            lineUpHours.events.contains { $0.startDateTime > shipDateTime }
        } ?? 0
    }
    
    var shipDateTime: Date {
        model?.shipDateTime ?? Date()
    }

	private var model: LoadOfflineModeLineUpUseCaseModel?

	private var loadOfflineModeLineUpUseCase: LoadOfflineModeLineUpUseCaseProtocol

	init(
		loadOfflineModeLineUpUseCase: LoadOfflineModeLineUpUseCaseProtocol = LoadOfflineModeLineUpUseCase()
	) {
		self.loadOfflineModeLineUpUseCase = loadOfflineModeLineUpUseCase
	}

	func onAppear() {
		Task { [weak self] in
			guard let self = self else { return }
			let result = await executeUseCase {
				await self.loadOfflineModeLineUpUseCase.execute()
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
	private func updateUI(with model: LoadOfflineModeLineUpUseCaseModel) {
		self.model = model
	}
}
