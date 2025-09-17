//
//  EntertainmentView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 23.3.25.
//

import SwiftUI
import VVUIKit

struct EntertainmentView: View {
    var title: String
    var timePeriod: String
    var location: String

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(title)
                .font(.vvBodyBold)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 5) {
                Text(timePeriod)
                    .font(.vvSmall)
                    .foregroundColor(Color.slateGray)
                Image("Marker")
                Text(location)
                    .font(.vvSmall)
                    .foregroundColor(Color.slateGray)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, Spacing.space12)
        .padding(.vertical, Spacing.space8)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusValues.defaultCornerRadius)
                   .stroke(Color.black.opacity(0.1), lineWidth: 1)
           )
    }
}

#Preview {
    EntertainmentView(title: "Entertainment", timePeriod: "10:00 - 12:00", location: "The Deck")
}
