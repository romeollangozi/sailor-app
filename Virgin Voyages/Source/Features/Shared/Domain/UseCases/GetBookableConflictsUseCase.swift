//
//  GetBookableConflictsUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 12.3.25.
//


protocol GetBookableConflictsUseCaseProtocol {
	func execute(input: BookableConflictsInputModel) async throws -> [BookableConflictsModel]
}

class GetBookableConflictsUseCase: GetBookableConflictsUseCaseProtocol {
	private let currentSailorManager: CurrentSailorManagerProtocol
	private let bookableConflictsRepository: BookableConflictsRepositoryProtocol
	private let sailorsRepository: SailorsRepositoryProtocol
	
	init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		 bookableConflictsRepository: BookableConflictsRepositoryProtocol = BookableConflictsRepository(),
		 sailorsRepository: SailorsRepositoryProtocol = SailorsRepository()
	) {
		self.currentSailorManager = currentSailorManager
		self.bookableConflictsRepository = bookableConflictsRepository
		self.sailorsRepository = sailorsRepository
	}
	
	func execute(input: BookableConflictsInputModel) async throws -> [BookableConflictsModel] {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		let requestInput = input.toDomain(voyageNumber: currentSailor.voyageNumber, reservationNumber: currentSailor.reservationNumber, shipCode: currentSailor.shipCode)
		
		let result = try await bookableConflictsRepository.fetchBookableConflicts(input: requestInput)
		
		if result.isEmpty {
			return []
		}
		
		let mySailors = try await sailorsRepository.fetchMySailors(reservationGuestId: currentSailor.reservationGuestId, reservationNumber: currentSailor.reservationNumber, useCache: true)
		
		return result.map { transform(for: $0, mySailors: mySailors, currentSailor: currentSailor)}
	}
	
	func transform(for conflict: BookableConflicts, mySailors: [SailorModel], currentSailor: CurrentSailor) -> BookableConflictsModel {
		let conflictedSailors: [BookableConflictsModel.Sailor] = conflict.sailors.map({ sailorInConflict in
			let sailor = mySailors.first(where: {$0.reservationGuestId == sailorInConflict.reservationGuestId})
			
			return .init(reservationGuestId: sailorInConflict.reservationGuestId,
						 status: sailorInConflict.status,
						 name: sailor?.name ?? "",
						 bookableType: sailorInConflict.bookableType,
						 profileImageUrl: sailor?.profileImageUrl,
						 appointmentId: sailorInConflict.appointmentId
			)
		})
		
		return BookableConflictsModel(slotId: conflict.slotId,
									  slotStatus: conflict.slotStatus,
									  sailors: conflictedSailors)
	}
}
