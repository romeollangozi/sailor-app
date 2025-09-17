//
//  GetUserProfileUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 10.2.25.
//

import Foundation

protocol GetUserProfileUseCaseProtocol {
    func execute() async -> UserProfile?
}

class GetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    let userRepository: UserProfileRepository
    
    init(userRepository: UserProfileRepository = .init()) {
        self.userRepository = userRepository
    }
    
    func execute() async -> UserProfile? {
        try? await self.userRepository.getUserProfile()
    }
}
