//
//  GetShouldDetectMotionUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/25/25.
//

import Foundation

protocol GetShouldDetectMotionUseCaseProtocol {
    func execute() -> Bool
}

class GetShouldDetectMotionUseCase: GetShouldDetectMotionUseCaseProtocol {
    
    private let authenticationService: AuthenticationServiceProtocol
    private let getUserShoresideOrShipsideLocationUseCase: GetUserShoresideOrShipsideLocationUseCaseProtocol
    private let musterModeStatusUseCase: MusterModeStatusUseCaseProtocol

    init(authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared,
         getUserShoresideOrShipsideLocationUseCase: GetUserShoresideOrShipsideLocationUseCaseProtocol = GetUserShoresideOrShipsideLocationUseCase(),
         musterModeStatusUseCase: MusterModeStatusUseCaseProtocol = MusterModeStatusUseCase()) {
        self.authenticationService = authenticationService
        self.getUserShoresideOrShipsideLocationUseCase = getUserShoresideOrShipsideLocationUseCase
        self.musterModeStatusUseCase = musterModeStatusUseCase
    }
    
    func execute() -> Bool {
        
        let sailorLocation = getUserShoresideOrShipsideLocationUseCase.execute()
        let musterModeStatus = musterModeStatusUseCase.getMusterMode()

        if authenticationService.isLoggedIn(), sailorLocation == .ship, musterModeStatus != .important {
            return true
        }
        
        return false
    }
    
}
