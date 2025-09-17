//
//  MockGetUserShoresideOrShipsideLocationUseCase.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 6/27/25.
//

import Foundation
@testable import Virgin_Voyages

class MockGetUserShoresideOrShipsideLocationUseCase: GetUserShoresideOrShipsideLocationUseCaseProtocol {
    
    var mockSailorLocation: SailorLocation = .shore
    
    func execute() -> SailorLocation {
        return mockSailorLocation
    }
    
}
