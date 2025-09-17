//
//  GetVipBenefitsUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.3.25.
//

protocol GetVipBenefitsUseCaseProtocol {
	func execute() async throws -> VipBenefitsModel
}

final class GetVipBenefitsUseCase: GetVipBenefitsUseCaseProtocol {

	private let vipBenefitsRepository: VipBenefitsRepositoryProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol
	private let localizationManager: LocalizationManagerProtocol
	private let lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol

	init(
		vipBenefitsRepository: VipBenefitsRepositoryProtocol = VipBenefitsRepository(),
		currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		localizationManager: LocalizationManagerProtocol = LocalizationManager.shared,
		lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol = LastKnownSailorConnectionLocationRepository()
	) {
		self.vipBenefitsRepository = vipBenefitsRepository
		self.currentSailorManager = currentSailorManager
		self.localizationManager = localizationManager
		self.lastKnownSailorConnectionLocationRepository = lastKnownSailorConnectionLocationRepository
	}

	func execute() async throws -> VipBenefitsModel {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
		let guestTypeCode = currentSailor.guestTypeCode
		guard let response = try await vipBenefitsRepository.fetchVipBenefits(
			guestTypeCode: guestTypeCode,
			shipCode: currentSailor.shipCode
		) else {
			throw VVDomainError.genericError
		}

		let sailorLocation = lastKnownSailorConnectionLocationRepository.fetchLastKnownSailorConnectionLocation()
		let isOnShip = sailorLocation == .ship
		let contactImageName: String = isOnShip ? "Messenger" : "ContactEmail"

		return VipBenefitsModel(
			benefits: response.benefits,
			supportEmailAddress: response.supportEmailAddress,
			title: localizationManager.getString(for: .myVoyageHeadline),
			subtitle: localizationManager.getString(for: .myVoyageBody),
			contactTitle: "Contact your Rockstar Agent",
			contactImage: contactImageName,
			sailorLocation: sailorLocation
		)
	}
}
