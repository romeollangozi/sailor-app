//
//  MockGetShoreThingItemUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 30.5.25.
//

import Foundation
@testable import Virgin_Voyages

class MockGetShoreThingItemUseCase: GetShoreThingItemUseCaseProtocol {
	
    var didCallExecute = false
    var result: ShoreThingItem?
    
	func execute(id: String, slotId: String, portCode: String, portStartDate: String, portEndDate: String) async throws -> Virgin_Voyages.ShoreThingItem {
        didCallExecute = true
        if let result {
            return result
        }
        
        throw VVDomainError.notFound
    }
}
