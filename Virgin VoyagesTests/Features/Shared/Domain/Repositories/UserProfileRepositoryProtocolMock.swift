//
//  UserProfileRepositoryProtocolMock.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 14.11.24.
//

import Foundation
@testable import Virgin_Voyages

class UserProfileRepositoryProtocolMock: UserProfileRepositoryProtocol {
    var getUserProfileReturnValue: UserProfile?
    var getUserProfileThrowableError: Error?
    
    func getUserProfile() async throws -> UserProfile? {
        if let error = getUserProfileThrowableError {
            throw error
        }
        return getUserProfileReturnValue
    }
}
