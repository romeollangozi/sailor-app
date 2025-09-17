//
//  SaveCitizenshipRepository.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 8.9.25.
//

import Foundation

protocol SaveCitizenshipRepositoryProtocol {
    func saveCitizenship(_ model: CitizenshipModel) async throws
}

final class SaveCitizenshipRepository: SaveCitizenshipRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func saveCitizenship(_ model: CitizenshipModel) async throws {
        _ = try await networkService.saveCitizenship(model.toNetworkDTO())
    }
}
