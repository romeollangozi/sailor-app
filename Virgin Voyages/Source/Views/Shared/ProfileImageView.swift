//
//  ProfileImageView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.9.24.
//

import SwiftUI

struct ProfileImageView: View {
    let size: CGFloat
    let profileImageUrl: String?
    let placeholderImage: Image
    let cameraImage: Image
    let cameraButtonOccurance: CameraButtonOccurance
    let cameraAction: () -> Void
    let showCameraButton: Bool
    
    init(size: CGFloat = 200.0,
         profileImageUrl: String? = nil,
         placeholderImage: Image = Image("ProfilePlaceholder"),
         cameraImage: Image = Image("CameraIcon"),
         cameraButtonOccurance: CameraButtonOccurance = .general,
         showCameraButton: Bool = true,
         cameraAction: @escaping () -> Void) {
        self.profileImageUrl = profileImageUrl
        self.placeholderImage = placeholderImage
        self.cameraImage = cameraImage
        self.cameraButtonOccurance = cameraButtonOccurance
        self.cameraAction = cameraAction
        self.showCameraButton = showCameraButton
        self.size = size
    }
    
    var body: some View {
        ZStack(alignment: cameraButtonOccurance.alignemnt) {
            if let imageUrl = profileImageUrl {
                AuthURLImageView(imageUrl: imageUrl, size: size, clipShape: .circle, defaultImage: "ProfilePlaceholder")
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            }else{
                placeholderImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            }
            
            if showCameraButton == true {
                VStack {
                    Spacer()
                    Button(action: {
                        cameraAction()
                    }) {
                        cameraImage
                            .resizable()
                            .scaledToFit()
                            .padding(cameraButtonOccurance.padding)
                            .frame(width: cameraButtonOccurance.size, height: cameraButtonOccurance.size)
                            .background(cameraButtonOccurance.backgroundColor)
                            .foregroundStyle(cameraButtonOccurance.foreGroundColor)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 5)
                        
                    }
                    .offset(cameraButtonOccurance.offset)
                    
                }
            }
        }
        .frame(width: size, height: size)
    }
}

extension ProfileImageView {
    enum CameraButtonOccurance {
        case general
        case profileSettingsPage
        
        
        var backgroundColor: Color {
            switch self {
            case .general: return .white
            case .profileSettingsPage: return .purple
            }
        }
        var foreGroundColor: Color {
            switch self {
            case .general: return .black
            case .profileSettingsPage: return .white
            }
        }
        
        var alignemnt: Alignment {
            switch self {
            case .general: return .trailing
            case .profileSettingsPage: return .leading
            }
        }
        var size: CGFloat {
            switch self {
            case .general: return (40)
            case .profileSettingsPage: return (36)
            }
        }
        
        var offset: CGSize {
            switch self {
            case.general: return .init(width: -5, height: -5)
            case.profileSettingsPage: return .init(width: 15, height: -15)
            }
        }
        
        var padding: CGFloat {
            switch self {
            case.general: return 8.0
            case.profileSettingsPage: return 7.0
            }
        }
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView(
            profileImageUrl: "", placeholderImage: Image("ProfilePlaceholder"),
            cameraImage: Image("ProfileCamera"),
            cameraAction: {}
        )
    }
}
