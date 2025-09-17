//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/22/24.
//

import SwiftUI
import VVUIKit

struct PaymentSummaryExistingPaymentMethodView: View {
	let cardIssuer: String
	let maskedCardNumber: String
	let cardImage: UIImage?
    let payWithExistingCard: (() -> Void)?
    let payWithOtherCard: (() -> Void)?
	@Binding var payWithExistingCardLoading: Bool
	@Binding var payWithDifferentCardLoading: Bool

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			PaymentSummaryCardDetailsView(cardIssuer: cardIssuer,
										  maskedCardNumber: maskedCardNumber,
										  cardImage: cardImage)
			LoadingButton(title: "Pay with existing card", loading: payWithExistingCardLoading) {
				payWithExistingCard?()
			}
			.buttonStyle(PrimaryButtonStyle())
			LoadingButton(title: "Pay with a different card", loading: payWithDifferentCardLoading) {
				payWithOtherCard?()
			}
			.buttonStyle(SecondaryButtonStyle())
		}
		.padding([.leading, .top, .trailing], 24.0)
		.padding(.bottom, 16.0)
	}
}

struct PaymentSummaryConfirmBookingExistingPaymentMethodView: View {
    let payWithExistingCard: (() -> Void)?
    let isNonPaidBooking: Bool
    @Binding var payWithExistingCardLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LoadingButton(title: isNonPaidBooking ? "Confirm" : "Confirm Payment", loading: payWithExistingCardLoading) {
                payWithExistingCard?()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding([.leading, .top, .trailing], 24.0)
        .padding(.bottom, 16.0)
    }
}
