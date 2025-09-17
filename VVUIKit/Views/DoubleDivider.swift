//
//  DoubleDivider.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 16.1.25.
//

import SwiftUI

public struct DoubleDivider: View {
    let color: Color
    let lineHeight: CGFloat
    
    public init(color: Color = Color.lightMist, lineHeight: CGFloat = 4) {
        self.color = color
        self.lineHeight = lineHeight
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            Rectangle()
                .frame(height: lineHeight)

            Rectangle()
                .frame(height: lineHeight)
        }
        .foregroundStyle(color)
    }
}

#Preview("Dividers") {
    DoubleDivider()
    
    DoubleDivider(color: Color.black)
}
