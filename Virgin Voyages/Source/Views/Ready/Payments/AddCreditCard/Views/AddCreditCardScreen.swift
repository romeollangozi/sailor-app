//
//  AddCreditCardView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 7/7/24.
//

import SwiftUI

struct AddCreditCardScreen: View {
	@State private var content: AddCreditCardViewer.Content?

	var didDismiss: (() -> Void)
	var didAuthorizeCard: ((CreditCardDetails) -> Void)
	var paymentFailed: ((String) -> Void)

	var body: some View {
		ScreenView(name: "Credit Card", viewModel: AddCreditCardViewer(), content: $content) { url in
			AddCreditCardView(url: url,
							  back: {
				didDismiss()
			}, didAuthorizeCard: { cardDetails in
				didAuthorizeCard(cardDetails)
			}, paymentFailed: { error in
				paymentFailed(error)
			})
		}
	}
}
