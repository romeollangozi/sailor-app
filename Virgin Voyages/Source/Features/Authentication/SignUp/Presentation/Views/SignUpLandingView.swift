//
//  SignUpLandingView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 26.8.24.
//

import SwiftUI
import VVUIKit

struct SignUpLandingView: View {
    
    @State private var viewModel: SignUpLandingViewModelProtocol
    
    init(viewModel: SignUpLandingViewModelProtocol) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        toolbar()
        
        VStack(spacing: 20) {
            AnchorView()

            Text("Permission to come aboard!")
                .fontStyle(.largeTitle)
                .multilineTextAlignment(.center)
            
            Text("Let's get you signed-up and ready to go.")
                .fontStyle(.largeTagline)
                .foregroundColor(.gray)
            
            signUpButton()
            if !viewModel.isShipboard {
                socialButtons()
            }
            tappableText()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .padding(Paddings.defaultHorizontalPadding)
		.navigationBarBackButtonHidden() 
		.onAppear {
			viewModel.onAppear()
		}
    }
    
    
    // MARK: - Buttons
    private func signUpButton() -> some View {
        Button("Sign up with email") {
            viewModel.navigateToSignUpWithEmail()
        }
        .buttonStyle(PrimaryButtonStyle())
        .padding(.vertical)
        
    }
    
    private func socialButtons() -> some View {
        VStack {
        Text("Sign up with Social:")
            .fontStyle(.headline)
            .foregroundColor(.titleColor)
            Group {
                HStack(spacing: 15) {
                    Button {
                        Task {
                            let login = await viewModel.loginWithAppleId()
                            if login == false {
								viewModel.navigateToSocialProfileView()
                            }
                        }
                    } label: {
                        Image(systemName: "apple.logo")
                            .imageScale(.large)
                            .fontStyle(.title)
                    }
                    .frame(width: Sizes.socialLoginButtonSize, height: Sizes.socialLoginButtonSize)
                    .foregroundStyle(.background)
                    .background(.primary)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(.secondary)
                    }
                    
                    Button {
                        Task {
                            let login = await viewModel.loginWithFacebook()
                            if login == false {
								viewModel.navigateToSocialProfileView()
                            }
                        }
                    } label: {
                        Image("Facebook")
                            .resizable()
                            .frame(width: Sizes.socialLoginButtonSize, height: Sizes.socialLoginButtonSize)
                    }
                    .foregroundStyle(.black)
                    .background(.white)
                    .clipShape(Circle())

                    Button {
                        showGoogleLoginView()
                    } label: {
                        Image("Google")
                            .resizable()
                            .frame(width: Sizes.socialLoginButtonSize, height: Sizes.socialLoginButtonSize)
                    }
                    .foregroundStyle(.black)
                    .background(.white)
                    .clipShape(Circle())
                }
            }
        }

    }
    
    private func toolbar() -> some View {
        Toolbar(buttonStyle: .closeButton) {
            viewModel.dismissSheet()
        }
    }

    private func tappableText() -> some View {
        Text("By continuing, you are accepting our \(Text("[Terms of Service](https://www.virginvoyages.com/addl-terms-and-conditions)").underline()) and \(Text("[privacy policy.](https://www.virginvoyages.com/privacy-notice)").underline())")
            .tint(Color("Section Color"))
            .foregroundColor(.privacyPolicyColor)
            .multilineTextStyle(.lightLink, alignment: .center)
    }
    
    private func showGoogleLoginView() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let rootViewController = window.rootViewController {
            Task {
                let login = await viewModel.loginWithGoogle(presentingViewController: rootViewController)
                if login == false {
                    viewModel.navigateToSocialProfileView()
                }
            }
        }
    }
}
