//
//  PaymentMethodScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/5/24.
//

import SwiftUI
import Foundation

@Observable class PaymentMethodScreenViewModel: PaymentMethodScreenViewModelProtocol {

	var imageURL: URL?
	var backgroundColor: Color

	var screenState: ScreenState = .loading

	var repository: PaymentMethodRepositoryProtocol

	var paymentMethodViewModel: PaymentMethodViewModelProtocol!
    var completionPercentage: Double

    init(imageURL: URL?, backgroundColor: Color, repository: PaymentMethodRepositoryProtocol, completionPercentage: Double) {
		self.imageURL = imageURL
		self.backgroundColor = backgroundColor
		self.repository = repository
        self.completionPercentage = completionPercentage
	}

	func loadPayments() {
		screenState = .loading
		Task {
			if let paymentMethodModel = await repository.fetchPaymentMethodModel() {
				DispatchQueue.main.async { [weak self] in
					self?.showContent(paymentMethodModel: paymentMethodModel)
				}
			} else {
				DispatchQueue.main.async { [weak self] in
					self?.showError()
				}
			}
		}
	}

	func showContent(paymentMethodModel: PaymentMethodModel) {
		paymentMethodViewModel = PaymentMethodViewModel(imageURL: imageURL,
															  backgroundColor: backgroundColor,
															  paymentMethodModel: paymentMethodModel,
														repository: repository,
                                                        completionPercentage: completionPercentage)
		screenState = .content
	}

	func showError() {
		screenState = .error
	}

	func refresh() {
		loadPayments()
	}
}
