//
//  GetLookupUseCase.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 13.3.25.
//

import Foundation

protocol GetLookupUseCaseProtocol {
    func execute() async throws -> Lookup
}

final class GetLookupUseCase: GetLookupUseCaseProtocol {
    private let lookupRepository: GetLookupRepositoryProtocol
    
    init(lookupRepository: GetLookupRepositoryProtocol = GetLookupRepository()) {
        self.lookupRepository = lookupRepository
    }
    
    func execute() async throws -> Lookup {
		guard let response = try await lookupRepository.fetchLookupData(useCache: true) else {
            throw VVDomainError.genericError
        }
		
        return response
    }
}
