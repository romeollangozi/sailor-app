//
//  SavePaymentMethodUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/10/24.
//

import Foundation

class SavePaymentMethodUseCase {

	private var repository: PaymentMethodRepositoryProtocol

	init(repository: PaymentMethodRepositoryProtocol) {
		self.repository = repository
	}

	func execute(paymentMethodModel: PaymentMethodModel, paymentType: PaymentMethodType) async -> Bool {
		return await repository.save(paymentMethodModel: paymentMethodModel, paymentType: paymentType)
	}
}
