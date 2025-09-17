//
//  MockGetTreatmentDetailsUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 30.5.25.
//

@testable import Virgin_Voyages

class MockGetTreatmentDetailsUseCase: GetTreatmentDetailsUseCaseProtocol {
    var result: TreatmentDetails?
    func execute(treatmentId: String) async throws -> TreatmentDetails {
        if let result {
            return result
        }
        
        throw VVDomainError.notFound
    }
}
