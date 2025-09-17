//
//  EateriesConflictsRepository.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 27.11.24.
//

protocol EateryConflictRepositoryProtocol {
    func getConflicts(input: EateryConflictsInput) async throws -> EateryConflicts?
}

final class EateryConflictRepository: EateryConflictRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func getConflicts(input: EateryConflictsInput) async throws -> EateryConflicts? {
        guard let response = try await networkService.getEateryConflicts(request: input.toRequestBody()) else { return nil }
        
        return EateryConflicts.map(from: response)
    }
}
