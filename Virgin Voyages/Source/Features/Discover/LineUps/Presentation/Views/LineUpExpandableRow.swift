//
//  LineUpExpandableRow.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 12.8.25.
//

import SwiftUI
import VVUIKit

struct LineUpExpandableRow<Content>: View where Content: View {
    let selectedDay: String
    var event: LineUpEvents
    @ViewBuilder var label: () -> Content
    @State private var showContent = false
    
    var body: some View {
        VStack(spacing: .zero) {
            Button {
                withAnimation {
                    showContent.toggle()
                }
            } label: {
                header()
            }
            .buttonStyle(PlainButtonStyle())
            
            if showContent {
                label()
                    .frame(maxWidth: .infinity)
                    .background(.background)
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Spacing.space8))
        .overlay(
            RoundedRectangle(cornerRadius: Spacing.space8)
                .stroke(Color.iconGray, lineWidth: 1)
        )
    }
    
    private func header() -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(spacing: .zero) {
                Text("\(selectedDay)'s Must-See Events")
                    .font(.vvHeading5Bold)
                
                Spacer()
                
                Image(systemName: "chevron.\(showContent ? "up" : "down")")
                    .frame(width: Spacing.space24, height: Spacing.space24)
                    .foregroundColor(.white)
                    .background(Color.white.opacity(0.20))
                    .clipShape(RoundedRectangle(cornerRadius: 32))
            }
            .padding(.vertical, Spacing.space12)
            .padding(.horizontal, Spacing.space16)
            .background(Color.rubyRed)
            
            if !showContent {
                ForEach(event.items.prefix(5), id: \.id) { item in
                    HStack(spacing: Spacing.space16) {
                        Text(item.name)
                            .font(.vvSmallBold)
                            .foregroundColor(Color.blackText)
                            .lineLimit(1)    
                        
                        Spacer()
                        
                        Text(item.timePeriod)
                            .font(.vvSmallBold)
                            .foregroundColor(Color.blackText)
                    }
                    .padding(.horizontal, Spacing.space16)
                    .padding(.top, Spacing.space8)
                    .padding(.bottom, Spacing.space12)
                }
            }
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    LineUpExpandableRow(selectedDay: "", event: LineUpEvents.sample().first!) {
        Text("LineUp Detail")
    }
}
