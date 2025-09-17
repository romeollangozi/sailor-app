//
//  WalletScreen.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/20/23.
//

import SwiftUI

struct WalletScreen: View {
	var wallet: ShipWallet
	
    var body: some View {
        ZStack{
            Color.white
            List {
                WalletHeader(wallet: wallet)
                    .listRowInsets(EdgeInsets())
                
                if let days = wallet.days {
                    let dates = days.keys.sorted { $0 > $1 }
                    ForEach(dates, id: \.self) { date in
                        if let transactions = days[date] {
                            Section(date.format(.dateTitle)) {
                                ForEach(transactions, id: \.itemId) { transaction in
                                    TransactionRow(title: transaction.location, imageName: transaction.imageName, amount: transaction.totalAmount)
                                }
                            }
                            .fontStyle(.headline)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarHidden(true)
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}
