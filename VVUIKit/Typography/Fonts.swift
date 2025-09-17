//
//  fonts.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.1.25.
//

import SwiftUI
import Foundation

public enum FontType: String, CaseIterable {
    case normal = "VVCentra2-Book"
    case bold = "VVCentra2-Bold"
    case light = "VVCentra2-Light"
    case medium = "VVCentra2-Medium"
    case voyagesMedium = "Voyages-Headline"
    case voyagesBold = "Voyages-Display"
    case vesterbroBold = "Vesterbro-Bold"
}

public enum FontSize: CGFloat, CaseIterable {
    case size8 = 8
    case size10 = 10
    case size12 = 12
    case size14 = 14
    case size16 = 16
    case size18 = 18
    case size20 = 20
    case size24 = 24
    case size28 = 28
    case size32 = 32
    case size39 = 39
    case size58 = 58
}

extension Font {
    public static func custom(_ type: FontType, size: FontSize = .size14) -> Font {
        return Font.custom(type.rawValue, size: size.rawValue)
    }
    
    public static var vvExtraHeadingMedium: Font {
        Font.custom(.medium, size: .size58)
    }
    
    public static var vvHeading1: Font {
        Font.custom(.normal, size: .size32)
    }
    
    public static var vvHeading1Bold: Font {
        Font.custom(.bold, size: .size32)
    }
    
    public static var vvHeading1Light: Font {
        Font.custom(.light, size: .size32)
    }
    
    public static var vvHeading1Medium: Font {
        Font.custom(.medium, size: .size32)
    }
    
    public static var vvHeading2: Font {
        Font.custom(.normal, size: .size28)
    }
    
    public static var vvHeading2Bold: Font {
        Font.custom(.bold, size: .size28)
    }
    
    public static var vvHeading2Light: Font {
        Font.custom(.light, size: .size28)
    }
    
    public static var vvHeading2Medium: Font {
        Font.custom(.medium, size: .size28)
    }
    
    public static var vvHeading3: Font {
        Font.custom(.normal, size: .size24)
    }
    
    public static var vvHeading3Bold: Font {
        Font.custom(.bold, size: .size24)
    }
    
    public static var vvHeading3Light: Font {
        Font.custom(.light, size: .size24)
    }
    
    public static var vvHeading3Medium: Font {
        Font.custom(.medium, size: .size24)
    }
    
    public static var vvHeading4: Font {
        Font.custom(.normal, size: .size20)
    }
    
    public static var vvHeading4Bold: Font {
        Font.custom(.bold, size: .size20)
    }
    
    public static var vvHeading4Light: Font {
        Font.custom(.light, size: .size20)
    }
    
    public static var vvHeading4Medium: Font {
        Font.custom(.medium, size: .size20)
    }
    
    public static var vvHeading5: Font {
        Font.custom(.normal, size: .size18)
    }
    
    public static var vvHeading5Bold: Font {
        Font.custom(.bold, size: .size18)
    }
    
    public static var vvHeading5Light: Font {
        Font.custom(.light, size: .size18)
    }
    
    public static var vvHeading5Medium: Font {
        Font.custom(.medium, size: .size18)
    }
    
    public static var vvBody: Font {
        Font.custom(.normal, size: .size16)
    }
    
    public static var vvBodyBold: Font {
        Font.custom(.bold, size: .size16)
    }
    
    public static var vvBodyLight: Font {
        Font.custom(.light, size: .size16)
    }
    
    public static var vvBodyMedium: Font {
        Font.custom(.medium, size: .size16)
    }
    
    public static var vvSmall: Font {
        Font.custom(.normal, size: .size14)
    }
    
    public static var vvSmallBold: Font {
        Font.custom(.bold, size: .size14)
    }
    
    public static var vvSmallLight: Font {
        Font.custom(.light, size: .size14)
    }
    
    public static var vvSmallMedium: Font {
        Font.custom(.medium, size: .size14)
    }
    
    public static var vvCaption: Font {
        Font.custom(.normal, size: .size12)
    }
    
    public static var vvCaptionBold: Font {
        Font.custom(.bold, size: .size12)
    }
    
    public static var vvCaptionLight: Font {
        Font.custom(.light, size: .size12)
    }
    
    public static var vvCaptionMedium: Font {
        Font.custom(.medium, size: .size12)
    }
    
    public static var vvTiny: Font {
        Font.custom(.normal, size: .size10)
    }
    
    public static var vvTinyBold: Font {
        Font.custom(.bold, size: .size10)
    }
    
    public static var vvTinyLight: Font {
        Font.custom(.light, size: .size10)
    }
    
    public static var vvTinyMedium: Font {
        Font.custom(.medium, size: .size10)
    }
    
    public static var vvMicro: Font {
        Font.custom(.normal, size: .size8)
    }
    
    public static var vvMicroBold: Font {
        Font.custom(.bold, size: .size8)
    }
    
    public static var vvMicroLight: Font {
        Font.custom(.light, size: .size8)
    }
    
    public static var vvMicroMedium: Font {
        Font.custom(.medium, size: .size8)
    }
    
    public static var vvVoyagesLargeMedium: Font {
        Font.custom(.voyagesMedium, size: .size39)
    }
    
    public static var vvVoyagesLargeBold: Font {
        Font.custom(.voyagesBold, size: .size39)
    }
    
    public static var vvVesterbroHeading3Bold: Font {
        Font.custom(.vesterbroBold, size: .size24)
    }
}

struct FontCombinationsPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(FontType.allCases, id: \.self) { fontType in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Font Type: \(fontType.rawValue)")
                            .font(.custom(.bold, size: .size12))
                        
                        ForEach(FontSize.allCases, id: \.self) { fontSize in
                            Text("Type: \(fontType).Size \(fontSize.rawValue)")
                                .font(.custom(fontType, size: fontSize))
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding()
        }
    }
}

#Preview {
    FontCombinationsPreview()
}
