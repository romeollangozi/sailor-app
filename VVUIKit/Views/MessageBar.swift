//
//  Alert.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 21.1.25.
//

import SwiftUI

public struct MessageBar: View  {
    let style: MessageBarStyle
    let text: String
    let fullWidth: Bool
    let cornerRadius: CGFloat?
    
    public init(style: MessageBarStyle, text: String, fullWidht: Bool = true, cornerRadius: CGFloat? = nil) {
        self.style = style
        self.text = text
        self.fullWidth = fullWidht
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            Text(text)
                .font(.vvSmallBold)
                .foregroundColor(style.textColor)
                .padding(.init(top: Spacing.space8, leading: Spacing.space12, bottom: Spacing.space8, trailing: Spacing.space12))
                .applyFullWidthIfNeeded(fullWidth: fullWidth)
        }.background(style.backgroundColor)
            .modifier(OptionalCornerRadius(cornerRadius))
    }
}

public enum MessageBarStyle {
    case Success
    case Info
    case Danger
    case Warning
    case Dark
    case Purple
    
    var backgroundColor: Color {
        switch self {
        case .Success:
            return Color.mintGreen
        case .Info:
            return Color.aquaBlue
        case .Danger:
            return Color.vvRed
        case .Warning:
            return Color.softYellow
        case .Dark:
            return Color.blackText
        case .Purple:
            return Color.deepPurple
        }
    }
    
    var textColor: Color {
        switch self {
        case .Success:
            return Color.blackText
        case .Info:
            return Color.blackText
        case .Danger:
            return Color.white
        case .Warning:
            return Color.blackText
        case .Dark:
            return Color.white
        case .Purple:
            return Color.white
        }
    }
}

extension View {
    @ViewBuilder
    func applyFullWidthIfNeeded(fullWidth: Bool) -> some View {
        if fullWidth {
            self.frame(maxWidth: .infinity, alignment: .leading)
        } else {
            self
        }
    }
}

private struct OptionalCornerRadius: ViewModifier {
    let cornerRadius: CGFloat?
    
    init(_ cornerRadius: CGFloat?) {
        self.cornerRadius = cornerRadius
    }
    
    func body(content: Content) -> some View {
        if let cornerRadius = cornerRadius {
            content.cornerRadius(cornerRadius)
        } else {
            content
        }
    }
}

#Preview("All Message Bars") {
    VStack(spacing: 16) {
        MessageBar(style: .Success, text: "Success", cornerRadius: 12)
        MessageBar(style: .Success, text: "Success")
        MessageBar(style: .Success, text: "Success", fullWidht: false)
        
        MessageBar(style: .Info, text: "Info", cornerRadius: 12)
        MessageBar(style: .Info, text: "Info")
        
        MessageBar(style: .Danger, text: "Danger", cornerRadius: 12)
        MessageBar(style: .Danger, text: "Danger")
        
        MessageBar(style: .Warning, text: "Warning", cornerRadius: 12)
        MessageBar(style: .Warning, text: "Warning")
        
        MessageBar(style: .Dark, text: "Dark", cornerRadius: 12)
        MessageBar(style: .Dark, text: "Dark")
        
        MessageBar(style: .Purple, text: "Purple", cornerRadius: 12)
        MessageBar(style: .Purple, text: "Purple")
    }
    .padding()
    .background(Color.lightMist)
}
