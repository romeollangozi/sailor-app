//
//  BigTitleSmallSubtitleHeaderText.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/28/25.
//

import SwiftUI
import VVUIKit

struct BigTitleSmallSubtitleHeaderText: View {
    
    let title: String
    let subTitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.space8) {
            Text(title)
                .foregroundStyle(Color.vvWhite)
                .font(.vvHeading1Bold)
            
            Text(subTitle)
                .foregroundStyle(Color.vvWhite)
                .font(.vvBody)
        }
    }
}

#Preview {
    BigTitleSmallSubtitleHeaderText(title: "Your ice is on the way.", subTitle: "Is something wrong? Let us know and we'll help you ASAP.")
        .padding()
        .background(
            Color.gray
        )
}
