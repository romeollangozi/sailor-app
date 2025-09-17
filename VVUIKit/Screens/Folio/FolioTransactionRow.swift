//
//  FolioTransactionRow.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 24.6.25.
//

import SwiftUI

struct FolioTransactionRow: View {
    let name: String
    let iconURL: String
    let profileImageURL: URL?
    let price: FolioPrice
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: .zero) {
                if let imageURL = profileImageURL {
                    URLImage(url: imageURL)
                        .frame(width: Spacing.space20, height: Spacing.space20)
                        .background(Color.white)
                        .clipShape(Circle())
                        .offset(x: -10, y: 5)
                }
                
                    HStack(spacing: Spacing.space8) {
                        if !iconURL.isEmpty {
                            ImageViewer(url: iconURL, width: Spacing.space40, height: Spacing.space40)
                        }
                        
                        Text(name)
                            .font(.vvBody)
                            .foregroundColor(.darkPurple)
                        
                        Spacer()
                        
                        FolioPriceLabel(price: price)
                    }
            }
            .padding(Spacing.space24)
        }
    }
}

#Preview {
    FolioTransactionRow(name: "Bar Tab", iconURL: "", profileImageURL: nil, price: FolioPrice(integerPart: "123", decimalPart: "45"), onTap: {})
}
