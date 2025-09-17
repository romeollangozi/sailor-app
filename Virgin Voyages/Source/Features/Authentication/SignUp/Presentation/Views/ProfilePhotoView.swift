//
//  ProfilePhotoView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.9.24.
//

import SwiftUI
import VVUIKit

extension ProfilePhotoView {
    static func create(viewModel:ProfilePhotoViewModelProtocol) -> ProfilePhotoView {
        return ProfilePhotoView(viewModel: viewModel)
    }
}

struct ProfilePhotoView: View {
    
    // MARK: - State properties
    @State private var viewModel: ProfilePhotoViewModelProtocol
    @State private var showCamera = false
    
    // MARK: - Init
    init(viewModel: ProfilePhotoViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        toolbar()
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    AnchorView()
                    Text("You. Look. Hot.")
                        .fontStyle(.largeTitle)
                        .multilineTextAlignment(.center)
                    
                    Text(" Do you really need a vacation glow when you already look so good?... of course you do.")
                        .fontStyle(.largeTagline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    
                    ProfileImageView(placeholderImage: viewModel.profileImage, showCameraButton: false,cameraAction: { self.showCamera = true })
                        .padding(.bottom, Paddings.defaultVerticalPadding64)
                        .padding(.top,  Paddings.defaultVerticalPadding48)
                    
                    VStack(spacing: Paddings.defaultVerticalPadding16) {
                        usePhotoBotton()
                        retakePhotoButton()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, Paddings.defaultHorizontalPadding)
            }
            .frame(maxWidth: .infinity)
            .fullScreenCover(isPresented: $showCamera) {
                CameraView(compressionQuality: 0.5, task: viewModel.cameraTask) { data in
                    viewModel.signUpInputModel.imageData = data
                } overlay: {
                    CameraSelfieOverlayView()
                }
            }

        }
    }
    
    // MARK: - Methods
    private func toolbar() -> some View {
        Toolbar(buttonStyle: .backButton) {
            viewModel.navigateBack()
        }
    }
    
    private func usePhotoBotton() -> some View {
        Button("Use Photo") {
            viewModel.navigateToSocialProfileView()
        }
        .buttonStyle(PrimaryButtonStyle())
    }
    
    private func retakePhotoButton() -> some View {
        Button("Retake photo") {
            self.showCamera = true
        }
        .buttonStyle(SecondaryButtonStyle())
    }
    
}

//Preview
struct ProfilePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = ProfilePhotoViewModel(signUpInputModel: SignUpInputModel())
        ProfilePhotoView(viewModel: mockViewModel)
    }
}
