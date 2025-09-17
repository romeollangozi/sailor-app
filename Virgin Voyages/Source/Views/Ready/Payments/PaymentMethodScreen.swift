//
//  PaymentMethodScreen.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/16/24.
//

import SwiftUI

protocol PaymentMethodScreenViewModelProtocol {
	var screenState: ScreenState { get set }
	var paymentMethodViewModel: PaymentMethodViewModelProtocol! { get }
	func loadPayments()
	func refresh()
}

struct PaymentMethodScreen: View {

	@State var viewModel: PaymentMethodScreenViewModelProtocol

	var body: some View {
		DefaultScreenView(state: $viewModel.screenState, content: {
			PaymentMethodView(paymentMethodViewModel: viewModel.paymentMethodViewModel)
		}, onRefresh: {
			viewModel.refresh()
		})
		.onAppear {
			viewModel.loadPayments()
		}
		.toolbarBackground(Color.clear, for: .navigationBar)
		.toolbarBackground(.hidden, for: .navigationBar)
	}
}
