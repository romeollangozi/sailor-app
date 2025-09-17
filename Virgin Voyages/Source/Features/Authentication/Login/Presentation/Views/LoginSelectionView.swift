//
//  LoginSelectionView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/22/24.
//

import SwiftUI
import VVUIKit
import AuthenticationServices

struct LoginSelectionView: View {

    @State private var viewModel: LoginSelectionViewModelProtocol = LoginSelectionViewModel()
        
	var body: some View {
		VStack {
			toolbar()
			header()
			loginOptionsView()
			Spacer()
            if !viewModel.isUserOnShip {
                socialLoginOptionsView()
                Spacer()
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
	}

	func toolbar() -> some View {
		Toolbar(buttonStyle: .closeButton) {
            viewModel.closeSheet()
		}
	}

	func header() -> some View {
		VStack(spacing: 8) {
			VectorImage(name: "Anchor")
				.frame(width: 50, height: 50)
				.foregroundStyle(.white)

			Text("Ahoy there Sailor!")
				.fontStyle(.largeTitle)
				.multilineTextAlignment(.center)

			Text("We love to see a familiar face. Sign in and it'll be just like the good old days.")
				.multilineTextAlignment(.center)
		}
        .padding(.bottom, 8.0)
	}

	func loginOptionsView() -> some View {
		VStack(spacing: 16) {
			Button("Login with Email") {
                viewModel.loginWithEmailButtonTapped()
			}
			.buttonStyle(PrimaryButtonStyle())

            Button(viewModel.loginButtonTitle) {
                viewModel.loginWithBookingReferenceButtonTapped()
			}
			.buttonStyle(SecondaryButtonStyle())
		}.padding(24.0)
	}

	func socialLoginOptionsView() -> some View {
		VStack(alignment: .center, spacing: 20) {
			Text("Login with Social:")
				.foregroundStyle(.secondary)
				.fontStyle(.headline)

			HStack(spacing: 15) {
				Button {
                    viewModel.loginWithAppleID()
				} label: {
					Image(systemName: "apple.logo")
						.imageScale(.large)
						.fontStyle(.title)
				}
				.frame(width: 50, height: 50)
				.foregroundStyle(.background)
				.background(.primary)
				.clipShape(Circle())
				.overlay {
					Circle()
						.stroke(.secondary)
				}

                Button {
                    
                    viewModel.loginWithFacebook()
                    
                } label: {
					Image("Facebook")
						.resizable()
						.frame(width: 50, height: 50)
				}
				.foregroundStyle(.black)
				.background(.white)
				.clipShape(Circle())


				Button {
                    showGoogleLoginView()
				} label: {
					Image("Google")
						.resizable()
						.frame(width: 50, height: 50)
				}
				.foregroundStyle(.black)
				.background(.white)
				.clipShape(Circle())
			}
		}
	}
    
    // MARK: - Show google login view
    private func showGoogleLoginView() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let rootViewController = window.rootViewController {

            viewModel.loginWithGoogle(presentingViewController: rootViewController)
        }
    }
}
