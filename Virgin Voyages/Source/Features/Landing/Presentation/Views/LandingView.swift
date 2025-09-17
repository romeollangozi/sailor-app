//
//  LandingView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/20/24.
//

import SwiftUI
import AVFoundation

extension LandingView {
	static func create(backgroundVideoPlayer: LoopingVideoPlayer,
                       showWiFiSheet: (() -> Void)? = nil,
                       currentDeepLink: DeepLinkType? = nil) -> LandingView {
        
		return LandingView(
            viewModel: LandingViewModel(
                backgroundVideoPlayer: backgroundVideoPlayer),
            showWiFiSheet: showWiFiSheet,
            currentDeepLink: currentDeepLink
        )
	}
}

struct LandingView: View {

	var showWiFiSheet: (() -> Void)? = nil
    var currentDeepLink: DeepLinkType? = nil
    
	@State private var viewModel: LandingViewModelProtocol

    init(viewModel: LandingViewModelProtocol, showWiFiSheet: (() -> Void)? = nil, currentDeepLink: DeepLinkType? = nil) {
		_viewModel = State(wrappedValue: viewModel)
		self.showWiFiSheet = showWiFiSheet
        self.currentDeepLink = currentDeepLink
	}

	var body: some View {
		VStack(spacing: 20) {
			Spacer()
			logoButton()
			Spacer()
			bottomButtons()
		}
        .padding(30)
        .sheet(item: $viewModel.appCoordinator.landingScreenCoordinator.sheetRouter.currentSheet, onDismiss: {
            // View was dismissed
            viewModel.dismissView()
        }, content: { sheetRoute in
            // View for sheetRoute
            viewModel.destinationView(for: sheetRoute)
        })
		.background {
			backgroundVideo()
				.ignoresSafeArea()
		}
		.onAppear {
			viewModel.requestPermissions()
		}
        .onChange(of: currentDeepLink) { _, newValue in
            viewModel.handleDeepLink(deepLink: newValue)
        }
	}

	private func bottomButtons() -> some View {
		Group {
			loginButton()
			signUpButton()
		}
		.opacity(viewModel.bottomButtonsVisible ? 1 : 0)
		.onAppear {
			withAnimation(.easeIn(duration: viewModel.bottomButtonsAnimationDurationInSeconds)) {
				viewModel.bottomButtonsVisible = true
			}
		}

	}

	private func logoButton() -> some View {
		BuildConfigurationView {
			Button {
				showWiFiSheet?()
			} label: {
				VStack(spacing: 2) {
					VectorImage(name: "Logo")
						.frame(width: 100, height: 100)
					Text("Voyages")
						.textCase(.uppercase)
						.font(.custom(FontStyle.virginVoyagesBold.fontName, size: 26))
						.foregroundStyle(.white)
				}
			}
		} releaseView: {
			VStack(spacing: 2) {
				VectorImage(name: "Logo")
					.frame(width: 100, height: 100)
				Text("Voyages")
					.textCase(.uppercase)
					.font(.custom(FontStyle.virginVoyagesBold.fontName, size: 26))
					.foregroundStyle(.white)
			}
		}
	}

	private func loginButton() -> some View {
		Button("Login") {
			viewModel.navigateToLogin()
		}
		.buttonStyle(PrimaryButtonStyle())
	}

	private func signUpButton() -> some View {
		Button("Sign up") {
			viewModel.navigateToSignUp()
		}
		.buttonStyle(SecondaryButtonStyle())
	}

	private func backgroundVideo() -> some View {
		LoopingVideoPlayerView(player: viewModel.backgroundVideoPlayer)
	}
}

// PreviewProvider
struct LandingView_Previews: PreviewProvider {

    class MockLandingViewModel: LandingViewModelProtocol {

        
		var bottomButtonsAnimationDurationInSeconds = 0.0
		var bottomButtonsVisible = true
		var showLoginSheet = false
		var showSignUpSheet = false
		var showDeactivatedAccountSheet = false
        var currentDeepLink: DeepLinkType? = nil
        var appCoordinator: AppCoordinator = .init()
        
		var backgroundVideoPlayer: LoopingVideoPlayer {
			let url = Bundle.main.url(forResource: "Ocean Waves", withExtension: "mp4")!
			return LoopingVideoPlayer(asset: .init(url: url))
		}

		func navigateToLogin() {
		}

		func navigateToSignUp() {
		}

		func requestPermissions() {
		}
        
        func handleDeepLink(deepLink: DeepLinkType?) {
        }
        
        func dismissView() {
            
        }
       
        func destinationView(for route: any BaseSheetRouter) -> AnyView {
            return AnyView(EmptyView())
        }
	}

	static var previews: some View {
		LandingView(viewModel: MockLandingViewModel())
	}
}
