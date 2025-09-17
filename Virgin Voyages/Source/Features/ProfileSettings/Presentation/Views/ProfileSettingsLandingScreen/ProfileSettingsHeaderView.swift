//
//  ProfileSettingsHeaderView.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 29.10.24.
//

import SwiftUI

struct ProfileSettingsHeaderView: View {
    let content: ProfileSettingsLandingScreenModel.ContentModel
    let cameraAction: () -> Void
    
    let imageSize: CGFloat = 230
    let height: CGFloat = 160
    let ofsset: CGPoint = .init(x: 50, y: -40)

    var body: some View {
        VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
            HStack {
                Spacer()
                ProfileImageView(size: imageSize,
                                 profileImageUrl: content.imageUrl ?? "",
                                 cameraButtonOccurance: .profileSettingsPage,
                                 showCameraButton: false,
                                 cameraAction: {
                    cameraAction()
                })
            }
            .frame(height: height)
            .offset(x: ofsset.x, y: ofsset.y)
            .padding(.bottom, Paddings.defaultVerticalPadding24)
            
            // Title
            Text(content.screenTitle ?? "")
                .fontStyle(.largeTitle)
            
            // Description
            Text(content.screenDescription ?? "")
                .fontStyle(.body)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    VStack {
        ProfileSettingsHeaderView(content: .init(screenTitle: "Preview Voyage Title", screenDescription: "Preview description", imageUrl: "")){
            
        }
        Spacer()
    }.padding()
}
