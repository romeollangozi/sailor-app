//
//  PaymentSummaryLineItemContentView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/17/24.
//

import SwiftUI

struct PaymentSummaryLineItemContentView: View {
	let lineItemViews: [PaymentSummaryLineItemView]

	var body: some View {
		VStack(spacing: 8) {
			ForEach(lineItemViews.indices, id: \.self) { index in
				lineItemViews[index]
			}
		}
		.padding([.top, .bottom], 16.0)
	}
}
