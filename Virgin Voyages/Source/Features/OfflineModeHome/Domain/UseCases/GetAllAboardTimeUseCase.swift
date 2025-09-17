//
//  GetAllAboardTimeUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/3/25.
//

import Foundation

protocol GetAllAboardTimeUseCaseProtocol {
	func execute(shipTime: Date) async -> AllAboardTimeModel?
}

class GetAllAboardTimeUseCase: GetAllAboardTimeUseCaseProtocol {
	private var allAboardTimesService: AllAboardTimesServiceProtocol

	init(allAboardTimesService: AllAboardTimesServiceProtocol = AllAboardTimesService()) {
		self.allAboardTimesService = allAboardTimesService
	}

	func execute(shipTime: Date) async -> AllAboardTimeModel? {
		await allAboardTimesService.getTodayAllAboardTime(shipTime: shipTime)
	}
}
