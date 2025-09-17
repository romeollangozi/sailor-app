//
//  VVSheetModal.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 15.10.24.
//

import SwiftUI

struct VVSheetModal<PrimaryStyle: ButtonStyle, SecondaryStyle: ButtonStyle>: View {
    var title: String?
    var subheadline: String?
    var primaryButtonText: String?
    var secondaryButtonText: String?
    var isEnabled: Bool = true
    var imageName: String? = "Porthole"
    var imageURL: String?
    var primaryButtonAction: (() -> Void)?
    var secondaryButtonAction: (() -> Void)?
    var dismiss: (() -> Void)?

    var primaryButtonStyle: PrimaryStyle
    var secondaryButtonStyle: SecondaryStyle

    init(
        title: String? = nil,
        subheadline: String? = nil,
        primaryButtonText: String? = nil,
        secondaryButtonText: String? = nil,
        isEnabled: Bool = true,
        imageName: String? = "Porthole",
        imageURL: String? = nil,
        primaryButtonAction: (() -> Void)? = nil,
        secondaryButtonAction: (() -> Void)? = nil,
        dismiss: (() -> Void)? = nil,
        primaryButtonStyle: PrimaryStyle = SecondaryButtonStyle(),
        secondaryButtonStyle: SecondaryStyle = SecondaryButtonStyle()
    ) {
        self.title = title
        self.subheadline = subheadline
        self.primaryButtonText = primaryButtonText
        self.secondaryButtonText = secondaryButtonText
        self.isEnabled = isEnabled
        self.imageName = imageName
        self.imageURL = imageURL
        self.primaryButtonAction = primaryButtonAction
        self.secondaryButtonAction = secondaryButtonAction
        self.dismiss = dismiss
        self.primaryButtonStyle = primaryButtonStyle
        self.secondaryButtonStyle = secondaryButtonStyle
    }

    var body: some View {
        ZStack {
            // Fullscreen black transparent background
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    dismiss?()
                }

            // Centered modal content
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss?()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                if let imageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 181, height: 180)
                        .padding(.bottom, 20)
                        .grayscale(isEnabled ? 0 : 1)
                }
                
                if let imageURL {
                    AuthURLImageView(imageUrl: imageURL,
                                     size: 180,
                                     clipShape: .circle,
                                     defaultImage: "Porthole")
                }

                if let title = title {
                    Text(title)
                        .fontStyle(.title)
                        .foregroundColor(Color.blackText)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.7)
                        .padding(.bottom, 10)
                }

                if let subheadline = subheadline {
                    Text(subheadline)
                        .fontStyle(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.vvGray)
                        .padding(.horizontal, 20)
                }

                if let primaryButtonText = primaryButtonText {
                    Button(primaryButtonText) {
                        primaryButtonAction?()
                    }
                    .buttonStyle(primaryButtonStyle)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                }

                if let secondaryButtonText = secondaryButtonText {
                    Button(secondaryButtonText) {
                        secondaryButtonAction?()
                    }
                    .buttonStyle(secondaryButtonStyle)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(radius: 10)
            )
            .frame(maxWidth: 350) // Adjust the width as needed
            .transition(.scale)
        }
    }
}

struct VVSheetModal_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VVSheetModal(
                title: "Confirmation",
                subheadline: "Are you sure you want to proceed?",
                primaryButtonText: "Confirm",
                secondaryButtonText: "Cancel",
                imageName: nil,
                imageURL: "https://cert.gcpshore.virginvoyages.com/dam/jcr:77d869a5-bd1c-4973-b1e4-3d6d0df72bee/IMG-RTS-Kettlebell-Discoball-v1-01-314x314.jpg",
                primaryButtonAction: {
                    print("Primary action executed")
                },
                secondaryButtonAction: {
                    print("Secondary action executed")
                },
                dismiss: {
                    print("Dismiss action executed")
                },
                primaryButtonStyle: SecondaryButtonStyle(),
                secondaryButtonStyle: SecondaryButtonStyle()
            )
        }
    }
}
