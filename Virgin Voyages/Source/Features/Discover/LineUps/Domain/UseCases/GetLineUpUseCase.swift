//
//  GetLineUpsUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 13.1.25.
//

import Foundation

protocol GetLineUpUseCaseProtocol {
	func execute(startDateTime: Date?, useCache: Bool) async throws -> LineUp
}

extension GetLineUpUseCaseProtocol {
	func execute(useCache: Bool = true) async throws -> LineUp {
		return try await execute(startDateTime: nil, useCache: useCache)
	}
}

final class GetLineUpUseCase: GetLineUpUseCaseProtocol {
	
	private let lineUpRepository: LineUpRepositoryProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol
	
	init(lineUpRepository: LineUpRepositoryProtocol = LineUpRepository(),
		 currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
		self.lineUpRepository = lineUpRepository
		self.currentSailorManager = currentSailorManager
	}
	
	func execute(startDateTime: Date? = nil, useCache: Bool = true) async throws -> LineUp {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		return try await lineUpRepository.fetchLineUp(reservationGuestId: currentSailor.reservationGuestId,
													  startDateTime: startDateTime?.toYearMMdd(),
															voyageNumber: currentSailor.voyageNumber,
													  reservationNumber: currentSailor.reservationNumber,
													  useCache: useCache)
	}
}
