//
//  DeletePaymentMethodUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/14/24.
//

import Foundation

class DeletePaymentMethodUseCase {

    private var repository: PaymentMethodRepositoryProtocol

    init(repository: PaymentMethodRepositoryProtocol) {
        self.repository = repository
    }

    func execute(paymentMethodModel: PaymentMethodModel, paymentType: PaymentMethodType) async -> Bool {
        return await repository.delete(paymentMethodModel: paymentMethodModel, paymentType: paymentType)
    }
}
