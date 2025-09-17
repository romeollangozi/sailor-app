//
//  AllAboardTimesService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/3/25.
//

import Foundation

protocol AllAboardTimesServiceProtocol {
	func syncAllAboardTimes() async throws
	func getTodayAllAboardTime(shipTime: Date) async -> AllAboardTimeModel?
}

class AllAboardTimesService: AllAboardTimesServiceProtocol {

	private let networkService: NetworkServiceProtocol
	private let allAboardTimesRepository: AllAboardTimesRepositoryProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol

	init(
		networkService: NetworkServiceProtocol = NetworkService.create(),
		allAboardTimesRepository: AllAboardTimesRepositoryProtocol = AllAboardTimesRepository(),
		currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()
	) {
		self.networkService = networkService
		self.allAboardTimesRepository = allAboardTimesRepository
		self.currentSailorManager = currentSailorManager
	}

	func syncAllAboardTimes() async throws {
		guard let sailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		let voyageNumber = sailor.voyageNumber

		let allAboardTimes = try await fetchAllAboardTimes(voyageNumber: voyageNumber)
		await allAboardTimesRepository.updateAllAboardTimes(allAboardTimes)
	}

	func getTodayAllAboardTime(shipTime: Date) async -> AllAboardTimeModel? {
		guard let model = await allAboardTimesRepository.fetchAllAboardTimes() else {
			return nil
		}

		let calendar = Calendar.current
		let todayComponents = calendar.dateComponents([.year, .month, .day], from: shipTime)

		if let match = model.allAboardTimes.first(where: {
			let components = calendar.dateComponents([.year, .month, .day], from: $0)
			return components == todayComponents
		}) {
			return AllAboardTimeModel(
				lastUpdated: model.lastUpdated,
				allAboardTime: match
			)
		}

		return nil
	}

	private func fetchAllAboardTimes(voyageNumber: String) async throws -> [Date] {
		guard let response = try await networkService.getAllAboardTimes(voyageNumber: voyageNumber) else {
			return []
		}
		return response.allAboardGuestsTimes.compactMap({ $0.toUTCDateTime() })
	}
}
