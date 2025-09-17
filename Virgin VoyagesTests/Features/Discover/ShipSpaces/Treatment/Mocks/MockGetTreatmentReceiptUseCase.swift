//
//  MockGetTreatmentReceiptUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 30.5.25.
//

@testable import Virgin_Voyages

class MockGetTreatmentReceiptUseCase: GetTreatmentReceiptUseCaseProtocol {
    var result: TreatmentReceiptModel?

    func execute(appointmentId: String) async throws -> TreatmentReceiptModel {
        if let result {
            return result
        }
        
        throw VVDomainError.notFound

    }
}
