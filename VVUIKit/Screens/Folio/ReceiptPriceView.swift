//
//  ReceiptPriceView.swift
//  VVUIKit
//
//  Created by Pajtim on 23.7.25.
//

import SwiftUI

struct ReceiptPriceView: View {
    let price: String
    let type: TransactionType
    let description: String

    var body: some View {
        let (sign, amount) = price.extractCurrencyComponents()
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            let amount = type == .refund ? "- \(sign) \(amount)" : "\(sign) \(amount)"

            Text(description)
                .font(.vvBody)
            Spacer()

            Text(amount)
                .font(.vvBodyBold)
        }
        .foregroundStyle(Color.slateGray)
    }
}
