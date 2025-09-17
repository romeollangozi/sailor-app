//
//  MyNextVoyageView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 3.6.25.
//

import SwiftUI
import VVUIKit

struct MyNextVoyageView: View {
    let voyageReservations: VoyageReservations
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: .zero) {
            myNextVoyageHeaderView()
            TicketLabelDivider(spacing: Paddings.defaultHorizontalPadding)
                .foregroundStyle(Color.borderGray)
            Button("Schedule Voyage") {
                action()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(Paddings.defaultVerticalPadding24)
        }
        .listRowStyle()
        .padding(.horizontal, Paddings.defaultVerticalPadding24)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 1)
        .shadow(color: Color.black.opacity(0.07), radius: 48, x: 0, y: 8)
    }

    private func myNextVoyageHeaderView() -> some View {
        VStack(spacing: .zero) {
            ZStack(alignment: .topLeading) {
                if let voyagePhotoURL = URL(string: voyageReservations.pageDetails.imageURL) {
                    FlexibleProgressImage(url: voyagePhotoURL)
                } else {
                    Color.gray.opacity(0.3)
                }
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        .black.opacity(0.40),
                        .black.opacity(0.40)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                
                myNextVoyageTopSection()
                    .padding(.trailing, 80)
            }
            .frame(height: 240)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
            .shadow(color: .black.opacity(0.07), radius: 24, x: 0, y: 8)
            
            Text("You have unlocked our exclusive onboard offer scoring a special discount on your next voyage plus onboard credit. Nice move!")
                .font(.vvSmall)
                .foregroundColor(Color.blackText)
                .padding(Paddings.defaultVerticalPadding24)
        }
    }
    
    private func myNextVoyageTopSection() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space8) {
            
            Text("My Next Virgin Voyage")
                .font(.vvHeading4Bold)
                .foregroundStyle(Color.vvWhite)
            
            Text("Booking Ref:")
                .font(.vvSmall)
                .foregroundStyle(Color.vvWhite)
            
            Text("Valid Until:")
                .font(.vvSmall)
                .foregroundStyle(Color.vvWhite)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.horizontal, .top], Paddings.defaultVerticalPadding24)
    }
}

// MARK: - Preview

#Preview {
    MyNextVoyageView(voyageReservations: .sample(), action: {})
}
