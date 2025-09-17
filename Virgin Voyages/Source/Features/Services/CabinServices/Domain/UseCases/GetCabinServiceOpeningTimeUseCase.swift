//
//  GetCabinServiceOpeningTimeUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 3.5.25.
//

protocol GetCabinServiceOpeningTimeUseCaseProtocol {
	func execute() async throws -> CabinServiceOpeninTime
}

final class GetCabinServiceOpeningTimeUseCase: GetCabinServiceOpeningTimeUseCaseProtocol {
	private let resourcesRepository: ResourcesRepositoryProtocol
	
	init(resourcesRepository: ResourcesRepositoryProtocol = ResourcesRepository()) {
		self.resourcesRepository = resourcesRepository
	}
	
	func execute() async throws -> CabinServiceOpeninTime {
		let stringResources = try await resourcesRepository.fetchStringResources(useCache: true)
		let assetResources = try await resourcesRepository.fetchAssetResources(useCache: true)
		
		return CabinServiceOpeninTime(
			imageURL: assetResources["preSailStates.cabinServicesSplashRoundImage"]?.link ?? "https://cert.gcpshore.virginvoyages.com/dam/jcr:0079cb42-cb31-4677-985c-1d401e2f206d/Cabin_Services_464x464.jpg" ,
			title: stringResources["preSailStates.cabinServicesSplashTitle"] ?? "Making your cabin...",
			subtitle: stringResources["preSailStates.cabinServicesSplashDescriptionText"] ?? "Once you’re on board, come back here for all your cabin wants and needs."
		)
	}
}

