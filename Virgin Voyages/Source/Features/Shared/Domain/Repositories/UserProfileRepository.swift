//
//  UserProfileRepository.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 29.10.24.
//

import Foundation

protocol UserProfileRepositoryProtocol {
    func getUserProfile() async throws -> UserProfile?
}

class UserProfileRepository: UserProfileRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func getUserProfile() async throws-> UserProfile? {
        guard let userProfileResponse = try await networkService.getUserProfile() else { return nil }
        
        return UserProfile.map(from: userProfileResponse)
    }
}
