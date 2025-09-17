//
//  SailorServiceButton.swift
//  Virgin Voyages
//
//  Created by TX on 7.3.25.
//

import SwiftUI

struct SailorServiceButton: View {
    let sailorType: SailorType
    let onTap: () -> Void
    
    var sailorServiceButtonText: String {
        switch sailorType {
        case .standard, .priority: return "Sailor Services"
        case .rockStar, .megaRockStar: return "Rockstar Agent"
        }
    }
    
    var sailorServiceButtonBackgroundColor: Color {
        switch sailorType {
        case .standard, .priority: return .accentColor
        case .rockStar, .megaRockStar: return Color.rockstarDark
        }
    }
    
    var sailorServiceButtonForegroundColor: Color {
        switch sailorType {
        case .standard, .priority: return .white
        case .rockStar, .megaRockStar: return .black
        }
    }
    
    
    var body: some View {
        VVRoundedIconButton(backgroundColor: sailorServiceButtonBackgroundColor, foregroundColor: sailorServiceButtonForegroundColor, text: sailorServiceButtonText, icon: "message") {
            onTap()
        }
        .frame(maxWidth: .infinity)
    }
    
}

#Preview {
    SailorServiceButton(sailorType: .standard) {}
}
