//
//  FolioBarTabRow.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 24.6.25.
//

import SwiftUI

struct FolioBarTabRow: View {
    let name: String
    let price: FolioPrice
    let imageURL: URL?
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: Spacing.space4) {
                if let imageURL = imageURL {
                    URLImage(url: imageURL)
                        .frame(width: Spacing.space20, height: Spacing.space20)
                        .background(Color.white)
                        .clipShape(Circle())
                        .offset(x: -10)
                }
                
                Text(name)
                    .font(.vvBody)
                    .foregroundColor(.darkPurple)
            }
            
            Spacer()
            
            FolioPriceLabel(price: price)
        }
        .padding(.horizontal, Spacing.space24)
        .padding(.vertical, Spacing.space32)
    }
}

#Preview {
    FolioBarTabRow(name: "Bar tab", price: FolioPrice(integerPart: "50", decimalPart: "20"), imageURL: nil)
}
