//
//  SignUpProfileImageView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.9.24.
//

import SwiftUI
import VVUIKit

extension SignUpProfileImageView {
    static func create(viewModel: SignUpProfileImageViewModelProtocol) -> SignUpProfileImageView {
        return SignUpProfileImageView(viewModel: viewModel)
    }
}

struct SignUpProfileImageView: View {
    
    // MARK: - State properties
    @State private var viewModel: SignUpProfileImageViewModelProtocol
    @State private var showCamera = false

    // MARK: - Init
    init(viewModel: SignUpProfileImageViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        toolbar()
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    AnchorView()
                    Text("Strike a pose")
                        .fontStyle(.largeTitle)
                        .multilineTextAlignment(.center)
                    
                    Text("Add a profile photo so your mates can find you easily. Smiling optional.")
                        .fontStyle(.largeTagline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    
                    ProfileImageView(cameraAction: { self.showCamera = true })
                        .padding(.bottom, Paddings.defaultVerticalPadding64)
                        .padding(.top,  Paddings.defaultVerticalPadding48)
                    
                    VStack(spacing: Paddings.defaultVerticalPadding16) {
                        addPhoto()
                        skipButton()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, Paddings.defaultHorizontalPadding)
            }
            .frame(maxWidth: .infinity)
            .fullScreenCover(isPresented: $showCamera) {
                CameraView(compressionQuality: 0.5, task: viewModel.cameraTask) { data in
                    viewModel.setupImage(from: data)
                    viewModel.navigateToProfilePhotoView()
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
    
    private func addPhoto() -> some View {
        Button("Add a photo") {
            self.showCamera = true
        }
        .buttonStyle(PrimaryButtonStyle())
    }
    
    private func skipButton() -> some View {
        Button("Skip for now") {
            viewModel.navigateToSocialProfileView()
        }
        .buttonStyle(SecondaryButtonStyle())
    }
    
}

//Preview
struct SignUpProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = SignUpProfileImageViewModel(signUpInputModel: SignUpInputModel())
        SignUpProfileImageView(viewModel: mockViewModel)
    }
}
