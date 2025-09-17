//
//  GetShipEatsOpeningTimeUseCase.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 7.5.25.
//

protocol GetShipEatsOpeningTimeUseCaseProtocol {
    func execute() async throws -> ShipEatsOpeninTime
}

final class GetShipEatsOpeningTimeUseCase: GetShipEatsOpeningTimeUseCaseProtocol {
    private let resourcesRepository: ResourcesRepositoryProtocol
    
    init(resourcesRepository: ResourcesRepositoryProtocol = ResourcesRepository()) {
        self.resourcesRepository = resourcesRepository
    }
    
    func execute() async throws -> ShipEatsOpeninTime {
		let stringResources = try await resourcesRepository.fetchStringResources(useCache: true)
		let assetResources = try await resourcesRepository.fetchAssetResources(useCache: true)
        
        return ShipEatsOpeninTime(
            imageURL: assetResources["preSailStates.shipEatsSplashRoundImage"]?.link ?? "https://cert.gcpshore.virginvoyages.com/dam/jcr:c0128d47-18b0-40d3-9ee5-23fb286d5e6f/RENDER-presail-ship-eats-food-314x314.jpg" ,
            title: stringResources["preSailStates.shipEatsSplashTitle"] ?? "ShipEats Delivery opens shipboard!",
            subtitle: stringResources["preSailStates.shipEatsSplashDescription"] ?? "Pop back when you’re onboard to order food delivery to your cabin from select venues across the ship. And, of course to pre-order breakfast in bed!"
        )
    }
}
