//
//  MockGetShoreThingReceiptDetailsUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 30.5.25.
//

import Foundation
@testable import Virgin_Voyages

class MockGetShoreThingReceiptDetailsUseCase: GetShoreThingReceiptDetailsUseCaseProtocol {

    var result: ShoreThingReceiptDetails?
    
    func execute(appointmentId: String) async throws -> ShoreThingReceiptDetails {
        if let result {
            return result
        }
        
        throw VVDomainError.notFound

    }
}
