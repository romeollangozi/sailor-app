//
//  MockGetLineUpDetailsUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 30.5.25.
//

import XCTest
@testable import Virgin_Voyages

class MockGetLineUpDetailsUseCase: GetLineUpDetailsUseCaseProtocol {
    var result: LineUpEvents.EventItem?
    
    func execute(eventId: String, slotId: String) async throws -> LineUpEvents.EventItem {
        if let result {
            return result
        }
        
        throw VVDomainError.notFound
    }
}
