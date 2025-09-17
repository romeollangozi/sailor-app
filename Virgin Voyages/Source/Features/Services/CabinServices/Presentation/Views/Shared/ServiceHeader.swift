//
//  ServiceHeader.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/24/25.
//

import SwiftUI
import VVUIKit

struct ServiceHeader: View {
    
    let spacing: Double
    let backButtonAction: () -> Void
    let title: String
    let subTitle: String
    let isConfirmationScreen: Bool
    let isSmallTitleWithBigSubtitleHeaderText: Bool
    
    init(spacing: Double,
         backButtonAction: @escaping () -> Void,
         title: String,
         subTitle: String,
         isConfirmationScreen: Bool = false,
         isSmallTitleWithBigSubtitleHeaderText: Bool = false
    ) {
        
        self.spacing = spacing
        self.backButtonAction = backButtonAction
        self.title = title
        self.subTitle = subTitle
        self.isConfirmationScreen = isConfirmationScreen
        self.isSmallTitleWithBigSubtitleHeaderText = isSmallTitleWithBigSubtitleHeaderText
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: Spacing.space0) {
            
            VStack(alignment: .leading, spacing: spacing) {
                
                if isConfirmationScreen {
                    
                    HStack {
                        
                        Spacer()
                        
                        backButton(isConfirmationScreen: isConfirmationScreen)
                    }
                    
                } else {
                    backButton(isConfirmationScreen: isConfirmationScreen)
                }
                
                if isSmallTitleWithBigSubtitleHeaderText {
                    SmallTitleBigSubtitleHeaderText(title: title,
                                                    subTitle: subTitle)
                } else {
                    BigTitleSmallSubtitleHeaderText(title: title,
                                                    subTitle: subTitle)
                }
                
            }
        }
        .padding(.horizontal, Spacing.space24)
        .padding(.top, Spacing.space48)
        
    }
    
    private func backButton(isConfirmationScreen: Bool) -> some View {
        
        VStack(alignment: .leading, spacing: Spacing.space0) {
            
            BackButton({
                backButtonAction()
            },
                       isCircleButton: true,
                       buttonIconName: isConfirmationScreen ? "xmark.circle.fill" : "arrow.backward.circle.fill")
            .opacity(0.8)
            .background(.clear)
            
        }
        
    }
    
}

#Preview {
    ServiceHeader(spacing: 80, backButtonAction: {}, title: "Maintenance", subTitle: "Is something wrong? Let us know and we'll help you ASAP.", isSmallTitleWithBigSubtitleHeaderText: true)
        .background(
            Color.gray
        )
}
