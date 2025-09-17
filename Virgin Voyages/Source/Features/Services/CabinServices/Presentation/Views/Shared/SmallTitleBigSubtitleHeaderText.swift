//
//  SmallTitleBigSubtitleHeaderText.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/28/25.
//

import SwiftUI
import VVUIKit

struct SmallTitleBigSubtitleHeaderText: View {
    
    let title: String
    let subTitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.space8) {
            Text(title)
                .foregroundStyle(Color.vvWhite)
                .font(.vvSmallBold)
            
            Text(subTitle)
                .foregroundStyle(Color.vvWhite)
                .font(.vvHeading1Bold)
        }
    }
}

#Preview {
    SmallTitleBigSubtitleHeaderText(title: "Maintenance", subTitle: "Is something wrong? Let us know and we'll help you ASAP.")
        .padding()
        .background(
            Color.gray
        )
    
}
