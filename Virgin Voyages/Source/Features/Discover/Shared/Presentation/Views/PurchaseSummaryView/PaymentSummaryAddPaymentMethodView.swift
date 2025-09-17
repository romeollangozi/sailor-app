//
//  PaymentSummaryAddPaymentMethodView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/17/24.
//

import SwiftUI
import VVUIKit

struct PaymentSummaryAddPaymentMethodView: View {
	let addCardAndPay: (() -> Void)?
	@Binding var addCardAndPayLoading: Bool

	var body: some View {
		VStack(spacing: 0) {
			LoadingButton(title: "Add card and Pay", loading: addCardAndPayLoading) {
				addCardAndPay?()
			}
			.buttonStyle(PrimaryButtonStyle())
		}
		.padding([.leading, .top, .trailing], 24.0)
		.padding(.bottom, 16.0)
	}
}
