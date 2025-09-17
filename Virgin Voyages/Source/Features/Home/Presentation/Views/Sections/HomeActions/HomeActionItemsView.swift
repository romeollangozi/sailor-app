//
//  HomeActionItemsView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 25.3.25.
//

import SwiftUI
import VVUIKit

struct HomeActionItemsView: View {
    let imageUrl: String
    let title: String
    let description: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
                .shadow(color: .black.opacity(0.07), radius: 24, x: 0, y: 8)
            
            HStack(spacing: Spacing.space16) {
                
                AuthURLImageView(imageUrl: imageUrl, size: 64, clipShape: .circle, defaultImage: "ProfilePlaceholder")
                
                VStack(alignment: .leading, spacing: Spacing.space8) {
                    
                    Text(title)
                        .font(.vvBodyBold)
                        .foregroundStyle(Color.charcoalBlack)
                    
                    Text(description)
                        .font(.vvSmall)
                        .foregroundStyle(Color.coolGray)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image("ForwardRed")
            }
            .padding(Spacing.space16)
        }
        .frame(height: 96)
    }

}

#Preview {
    HomeActionItemsView(
        imageUrl: "https://example.com/wallet.jpg",
        title: "Your Wallet",
        description: "View your onboard spending and balances."
    )
}
