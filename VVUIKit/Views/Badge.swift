//
//  Badge.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 16.1.25.
//

import SwiftUI

public struct Badge: View  {
    let style: BadgeStyle
    let text: String
    
    public init(style: BadgeStyle, text: String) {
        self.style = style
        self.text = text
    }
    
    public var body: some View {
        Text(text)
            .font(.vvCaption)
            .fontWeight(.bold)
            .foregroundColor(Color.darkGray)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(style == .Success ? Color.green : Color.aquaBlue)
            .cornerRadius(4)
    }
}

public enum BadgeStyle {
    case Success
    case Info
}


#Preview("Success Badge") {
    Badge(style: BadgeStyle.Success, text: "Booked")
}

#Preview("Info Badge") {
    Badge(style: BadgeStyle.Info, text: "Added")
}
