//
//  EateriesSlotsRepository.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 25.11.24.
//

protocol EateriesSlotsRepositoryProtocol {
    func fetchEateriesSlots(input: EateriesSlotsInput) async throws -> EateriesSlots?
}

final class EateriesSlotsRepository: EateriesSlotsRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func fetchEateriesSlots(input: EateriesSlotsInput) async throws -> EateriesSlots? {
        let response = try await networkService.getEateriesSlots(request: input.toRequestBody())
        
		return response?.toDomain()
    }
}
