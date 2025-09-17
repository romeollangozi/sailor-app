//
//  PlanAndBookActivityView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/15/25.
//

import SwiftUI
import VVUIKit

struct PlanAndBookActivityView: View {
    
    let item: VoyageActivitiesSection.VoyageActivityItem
    
    let constantCornerRadius: CGFloat = 8
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            if !item.imageUrl.isEmpty {
                FlexibleProgressImage(url: URL(string: item.imageUrl))
            } else {
                // Fallback background if no image is provided
                Color.gray.opacity(0.3)
            }
            
            // Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.clear,
                    Color.black.opacity(0.5),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Text
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.vvHeading4Bold)
                    .foregroundStyle(Color.vvWhite)
                    .padding([.horizontal, .bottom], Spacing.space16)
                    .shadow(color: Color.black.opacity(0.8), radius: 8, x: 0, y: 0)
                    
            }
        }
        .cornerRadius(constantCornerRadius)
        .shadow(
            color: Color.black.opacity(0.05),
            radius: 1,
            x: 0, y: 1
        )
        .shadow(
            color: Color.black.opacity(0.07),
            radius: 8,
            x: 0, y: 8
        )
    }
}

#Preview {
    
    let item = VoyageActivitiesSection.VoyageActivityItem(imageUrl: "",
                                                          name: "Purchase Add-ons",
                                                          code: "",
                                                          bookableType: .eatery,
                                                          layoutType: .full)
    
    PlanAndBookActivityView(item: item)
        .frame(width: .infinity, height: 140)
        .padding(.horizontal, 16)
}
