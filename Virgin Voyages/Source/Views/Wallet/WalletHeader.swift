//
//  WalletHeader.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/24/24.
//

import SwiftUI
import VVUIKit

struct WalletHeader: View {
	var wallet: ShipWallet

    var body: some View {
		VStack(spacing: 20) {
            Text("My Wallet")
                .font(.vvHeading1Bold)
                .foregroundStyle(.white)
                .padding(.top, Spacing.space48)
			if wallet.accountBalance > 0 {
				BalanceRow(header: "Amount", subheader: "due", balance: wallet.accountBalance) {
					EmptyView()
				}
			} else {
				BalanceRow(header: "Amount", subheader: "in credit", balance: wallet.accountBalance) {
					EmptyView()
				}
			}
			
			if let balance = wallet.barTabCredit {
				BalanceRow(header: "Bar tab", subheader: "remaining", balance: balance) {
					Text("Bar tab")
				}
			}
		}
		.padding(EdgeInsets(top: 30, leading: 15, bottom: 30, trailing: 15))
		.background {
			PurplePattern()
		}
		.background(.purple)
    }
}
