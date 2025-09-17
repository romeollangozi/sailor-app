//
//  MeHeaderButton.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.3.25.
//

import SwiftUI
import VVUIKit

struct MeHeaderButton: View {
    let image: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(image)
                    .frame(width: Sizes.defaultSize16, height: Sizes.defaultSize16)
                Text(text)
                    .font(.vvSmall)
            }
            .padding(Spacing.space8)
            .foregroundColor(.white)
            .background(Color.white.opacity(0.30))
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
}
