//
//  UpdateProfileUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 12.9.24.
//

import Foundation

// MARK: - Typealias
class UpdateProfileUseCase {
    
    // MARK: - Private properties
	private var service: NetworkServiceProtocol

    // MARK: - Init
    init(service: NetworkServiceProtocol = NetworkService.create()) {
        self.service = service
    }
    
    // MARK: - Execute
    func execute(forProfilePicture imageUrl: String) async -> Bool {
        do {
            let _ = try await service.updateProfileData(
                input: .init(
                    key: .photoUrl,
                    value: imageUrl,
                    action: .setUserProfile
                )
            )
            return true
        } catch {
            print("UpdateProfileUseCase for imageUrl error: \(error)")
            return false
        }
    }
}
