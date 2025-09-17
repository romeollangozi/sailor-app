//
//  FolioExpandableRow.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 12.6.25.
//

import SwiftUI

struct FolioExpandableRow<Content>: View where Content: View {
    var header: String
    var subheader: String
    var balance: String
    @ViewBuilder var label: () -> Content
    @State private var showContent = false
    
    var body: some View {
        VStack(spacing: .zero) {
            Button {
                withAnimation {
                    showContent.toggle()
                }
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(header)
                            .font(.vvCaptionBold)
                            .kerning(1.2)
                        Text(subheader)
                            .font(.vvCaptionBold)
                            .kerning(1.2)
                    }
                    .textCase(.uppercase)
                    
                    Spacer()
                    
                    HStack {
                        Text(balance)
                            .font(.vvHeading1Bold)
                        
                        Image(systemName: "chevron.\(showContent ? "up" : "down")")
                            .frame(width: Spacing.space24, height: Spacing.space24)
                    }
                }
                .padding(.vertical, Spacing.space32)
                .padding(.horizontal, Spacing.space24)
                .foregroundStyle(.white)
                .background(Color.darkPurple)
            }
            .buttonStyle(PlainButtonStyle())
            
            if showContent {
                label()
                    .frame(maxWidth: .infinity)
                    .background(.background)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Spacing.space8))
    }
}

#Preview {
    FolioExpandableRow(header: "Bar tab", subheader: "remaining", balance: "123.45") {
        Text("Wallet Detail")
    }
}
