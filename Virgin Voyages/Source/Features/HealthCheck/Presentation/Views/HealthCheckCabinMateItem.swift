//
//  HealthCheckCabinMateItem.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/9/25.
//

import SwiftUI
import VVUIKit

struct HealthCheckCabinMateItem: View {
    
    @Binding var isChecked: Bool
    
    let imageUrl: String
    let name: String
    
    var body: some View {
        VStack(spacing: Spacing.space0) {
            HStack(alignment: .center, spacing: Spacing.space16) {
                
                Button(action: {
                    isChecked.toggle()
                }) {
                    ZStack {
                        Image(systemName: isChecked ? "square.fill" : "square" )
                            .foregroundColor(isChecked ? .vvTropicalBlue : .mediumGray)
                            .font(isChecked ? Font.title.weight(.medium) : Font.title.weight(.ultraLight))
                            .frame(width: 20, height: 20)
                        
                        if isChecked {
                            Image(systemName: "checkmark")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .frame(width: 16, height: 16)
                        }
                    }
                
                }
                
                AuthURLImageView(imageUrl: imageUrl,
                                 size: 40,
                                 clipShape: .circle,
                                 defaultImage: "ProfilePlaceholder")
                
                Text(name)
                    .foregroundStyle(Color.vvBlack)
                    .font(.vvHeading5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, Spacing.space24)
            
            Divider()
                .foregroundStyle(Color.iconGray)
        }
        
    }
}

#Preview {
    VStack(spacing: 20) {
        
        HealthCheckCabinMateItem(isChecked: .constant(true), imageUrl: "", name: "Thomas Neumanstoff")
        
        HealthCheckCabinMateItem(isChecked: .constant(false), imageUrl: "", name: "Bertie Apst")
        
    }
    .padding()
}
