//
//  SailorProfileRepository.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/10/24.
//

import Foundation

protocol SailorProfileRepositoryProtocol {
    func profile() -> SailorProfile?
}

class SailorProfileRepository: SailorProfileRepositoryProtocol {
    
    var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared

    func profile() -> SailorProfile? {
        return authenticationService.userProfile?.toModel()
    }
}

extension Endpoint.GetUserProfile.Response {
    func toModel() -> SailorProfile {
        
        let dateOfBirth = birthDate.fromMMDDYYYYToDate()
        
        return SailorProfile(email: email,
                             firstName: firstName,
                             lastName: lastName,
                             dateOfBirth: dateOfBirth,
                             photoURL: photoUrl,
                             geneder: genderCode)
    }
}
