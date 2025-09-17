//
//  BookingConfirmationSheet.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 17.10.24.
//

import SwiftUI
import VVUIKit

struct BookingConfirmationSheet<PrimaryStyle: ButtonStyle, SecondaryStyle: ButtonStyle>: View {

    var title: String?
    var subheadline: String?
    var bodyText: String?
    var primaryButtonText: String?
    var secondaryButtonText: String?
    var isEnabled: Bool = true
    var imageName: String
    var isLoadingButtonAction: Binding<Bool> = .constant(false)
    var primaryButtonAction: (() -> Void)?
    var secondaryButtonAction: (() -> Void)?
    var dismiss: (() -> Void)?
    var hasDismissButton: Bool
    var primaryButtonStyle: PrimaryStyle
    var secondaryButtonStyle: SecondaryStyle
    
    var body: some View {
        VStack {
            if hasDismissButton {
                HStack {
                    Spacer()
                    SailableCloseButton() {
                        dismiss?()
                    }
                    .padding()
                }
            }
            VStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .padding(.bottom, 20)
                    .padding(.top, hasDismissButton ? Paddings.defaultVerticalPadding16 :Paddings.defaultVerticalPadding64)
                    .grayscale(isEnabled ? 0 : 1)
                
                if let title = title {
                    Text(title)
                        .foregroundStyle(Color.black)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 10)
                }
                
                if let subheadline = subheadline {
                    Text(subheadline)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                if let bodyText = bodyText {
                    Text(bodyText)
                        .fontStyle(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 5)
                }
            }
            .padding(20)
            DoubleDivider()

            VStack {
                if let primaryButtonText = primaryButtonText {
                    SecondaryButton(primaryButtonText, isLoading: isLoadingButtonAction.wrappedValue, action: {
                        primaryButtonAction?()
                    }, font: .vvBody)
                }
                if let secondaryButtonText = secondaryButtonText {
                    LinkButton(secondaryButtonText, font: .vvBody) {
                        secondaryButtonAction?()
                    }
                }
            }
            .padding(20)
            
            Spacer()
        }

    }
}


#Preview {
    BookingConfirmationSheet(title: "Payment Method", subheadline: "Please confirm if you'd like to proceed.", bodyText: "Refund value" ,primaryButtonText: "OK", secondaryButtonText: "Cancel", isEnabled: true, imageName: "CancelationConfirmed", isLoadingButtonAction: .constant(false), primaryButtonAction: {}, secondaryButtonAction: {}, dismiss: {}, hasDismissButton: false, primaryButtonStyle: SecondaryButtonStyle(), secondaryButtonStyle: SecondaryButtonStyle())
}

#Preview {
    BookingConfirmationSheet(title: "Payment Method", subheadline: "Please confirm if you'd like to proceed.", primaryButtonText: "OK", secondaryButtonText: "Cancel", isEnabled: false, imageName: "CancelationConfirmation", isLoadingButtonAction: .constant(false), primaryButtonAction: {}, secondaryButtonAction: {}, dismiss: {}, hasDismissButton: false, primaryButtonStyle: SecondaryButtonStyle(), secondaryButtonStyle: TertiaryButtonStyle())
}
