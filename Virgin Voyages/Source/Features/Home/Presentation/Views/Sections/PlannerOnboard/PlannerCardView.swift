//
//  PlannerCardView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 23.3.25.
//

import SwiftUI
import VVUIKit

struct PlannerCardView: View {
    var icon: String
    var text: String
    var highlightedText: String

    var body: some View {
        HStack(spacing: .zero) {
            Image(icon)
                .padding(.trailing, 6)
            BoldedTextView(text: text + highlightedText, placeholders: [highlightedText], textColor: Color.secondaryOceanBlue, defaultFont: .vvSmall)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.space8)
        .background(Color.lightBlue)
        .cornerRadius(12)
    }
}

struct PlannerPlaceholderView: View {
    let image: String?
    let title: String
    let padding: CGFloat = 10
    
    init(image: String? = nil, title: String) {
        self.image = image
        self.title = title
    }

    var body: some View {
        HStack(spacing: padding) {
            if let image {
                Image(image)
            }
            Text(title)
                .font(.vvBodyMedium)
                .foregroundColor(Color.slateGray)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, padding)
        .background(Color.lightYellow)
         .overlay(
             RoundedRectangle(cornerRadius: 12)
                 .stroke(Color.black.opacity(0.1), lineWidth: 1)
         )
    }
}


#Preview {
    VStack(spacing: 20) {
        PlannerCardView(icon: "CheckCircleBlue", text: "Dinner booked at", highlightedText: "Razzle Dazzle at 8pm")
        PlannerPlaceholderView(image: "ConfirmationNumber", title: "You have no more bookings today")
    }
   
}
