//
//  FontStyle.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/14/24.
//

import SwiftUI

enum FontStyle: Int, Equatable, CaseIterable, CustomStringConvertible {
    case virginVoyages
    case virginVoyagesBold
    case display
    case largeTitle
	case mediumTitle
    case title
    case smallTitle
    case lightTitle
    case headline
    case largeTagline
    case subheadline
    case smallButton
    case button
    case smallBody
    case body
    case lightBody
    case caption
    case largeCaption
    case boldTagline
    case boldSectionTagline
    case lightLink
    case italicDescription

    var description: String {
        switch self {
        case .virginVoyages: "Virgin Voyages"
        case .virginVoyagesBold: "Virgin Voyages Bold"
        case .display: "Large Nav"
        case .largeTitle: "Large Title"
		case .mediumTitle: "Medium Title"
        case .smallTitle: "Small Title"
        case .title: "Title"
        case .lightTitle: "Light Title"
        case .headline: "Headline"
        case .largeTagline: "Large Tagline"
        case .subheadline: "Subheadline"
        case .smallButton: "Small Button"
        case .button: "Button"
        case .smallBody: "Small Body"
        case .body: "Body"
        case .lightBody: "Light Body"
        case .caption: "Caption"
        case .largeCaption: "Large Caption"
        case .boldTagline: "Bold Tagline"
        case .boldSectionTagline: "Bold Section Tagline"
        case .lightLink: "Privacy policy"
        case .italicDescription: "Italic description"
        }
    }
    
    var fontName: String {
        switch self {
        case .virginVoyages: "Voyages-Headline"
        case .virginVoyagesBold: "Voyages-Display"
        case .display: "VVCentra2-Bold"
        case .largeTitle: "VVCentra2-Bold"
		case .mediumTitle: "VVCentra2-Bold"
        case .title: "VVCentra2-Medium"
        case .smallTitle: "VVCentra2-Medium"
        case .lightTitle: "VVCentra2-Light"
        case .headline: "VVCentra2-Medium"
        case .largeTagline: "VVCentra2-Book"
        case .subheadline: "VVCentra2-Book"
        case .smallButton: "VVCentra2-Medium"
        case .button: "VVCentra2-Medium"
        case .smallBody: "VVCentra2-Book"
        case .body: "VVCentra2-Book"
        case .lightBody: "VVCentra2-Light"
        case .caption: "VVCentra2-Book" // "VVCentra2-Bold"
        case .largeCaption: "VVCentra2-Bold"
        case .boldTagline: "VVCentra2-Bold"
        case .boldSectionTagline: "VVCentra2-Bold"
        case .lightLink: "VVCentra2-Light"
        case .italicDescription: "VVCentra2-LightItalic"
        }
    }

    var pointSize: CGFloat {
        switch self {
        case .virginVoyages: 44
        case .virginVoyagesBold: 44
        case .display: 40
        case .largeTitle: 32
		case .mediumTitle: 24
        case .title: 24 // 22
        case .lightTitle: 22
        case .smallTitle: 20
        case .headline: 16
        case .largeTagline: 18
        case .smallButton: 14
        case .button: 16
        case .subheadline: 14
        case .smallBody: 14
        case .body: 16
        case .lightBody: 16
        case .caption: 12 // 13
        case .largeCaption: 28
        case .boldTagline: 14
        case .boldSectionTagline: 12
        case .lightLink: 14
        case .italicDescription: 14
        }
    }
        
    var relativeSize: Font.TextStyle {
        switch self {
        case .virginVoyages: .largeTitle
        case .virginVoyagesBold: .largeTitle
        case .display: .largeTitle
        case .largeTitle: .largeTitle
		case .mediumTitle: .title
        case .title: .title
        case .lightTitle: .title
        case .smallTitle: .title
        case .headline: .headline
        case .largeTagline: .subheadline
        case .subheadline: .subheadline
        case .button: .body
        case .smallButton: .body
        case .smallBody: .caption
        case .body: .body
        case .lightBody: .body
        case .caption: .caption
        case .largeCaption: .title
        case .lightLink: .title
        case .boldTagline: .subheadline
        case .boldSectionTagline: .subheadline
        case .italicDescription: .subheadline
        }
    }
    
    var lineSpacing: CGFloat? {
        nil
    }
        
    var font: Font {
        Font.custom(fontName, size: pointSize, relativeTo: relativeSize)
    }
}

// MARK: View modifiers

struct FontModifer: ViewModifier {
    var font: FontStyle
    func body(content: Content) -> some View {
        content.font(font.font)
    }
}

struct FontMultilineTextModifer: ViewModifier {
    var font: FontStyle
    var alignment: TextAlignment
    func body(content: Content) -> some View {
        if let lineSpacing = font.lineSpacing {
            content.font(font.font)
                .lineSpacing(lineSpacing)
                .multilineTextAlignment(alignment)
        } else {
            content.font(font.font)
                .multilineTextAlignment(alignment)
        }
    }
}


extension View {
    func fontStyle(_ font: FontStyle) -> some View {
        modifier(FontModifer(font: font))
    }
    
    func multilineTextStyle(_ font: FontStyle, alignment: TextAlignment = .leading) -> some View {
        modifier(FontMultilineTextModifer(font: font, alignment: alignment))
    }
}

#Preview {
    List {
        Section("Fonts") {
            ForEach(FontStyle.allCases, id: \.description) { font in
                if font.description.count > 0 {
                    Text(font.description)
                        .fontStyle(font)
                }
            }
        }
        
        ForEach(FontStyle.allCases, id: \.description) { font in
            if font.description.count > 0 {
                Section(font.description) {
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                        .fontStyle(font)
                }
            }
        }
    }
}
