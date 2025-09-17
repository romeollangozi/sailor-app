//
//  NotDeliveredView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 18.2.25.
//

import SwiftUI
import VVUIKit

struct NotDeliveredView: View {
    var body: some View {
        HStack(spacing: Spacing.space4) {
            Text("Not delivered")
                .font(.vvBodyMedium)
                .foregroundColor(Color.orangeDark)
            
            ZStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: Spacing.space24, height: Spacing.space16)
                
                Image(systemName: "arrow.clockwise")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Spacing.space24, height: Spacing.space24)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, Spacing.space8)
        .padding(.vertical, Spacing.space4)
    }
}
