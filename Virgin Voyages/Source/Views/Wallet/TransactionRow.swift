//
//  TransactionListRow.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/21/23.
//

import SwiftUI

struct TransactionRow: View {
	var title: String
	var imageName: String
	var amount: Double
	
	var body: some View {
		Label {
			HStack {
				Text(title)
					.fontStyle(.body)
				
				Spacer()
				
				PriceLabel(amount: amount)
					.fontStyle(.body)
			}
		} icon: {
			Image(systemName: imageName)
		}
	}
}

#Preview {
	TransactionRow(title: "Razzle Dazzle", imageName: "fork.knife", amount: 12.34)
		.padding()
}
