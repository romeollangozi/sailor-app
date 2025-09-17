//
//  LandingSplashView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/21/24.
//

import SwiftUI
import AVFoundation

@Observable class LandingSplashViewModel {
	var logoAnimationDurationInSeconds = 1.0
	var logoVisible: Bool = false
	var backgroundVideoPlayer: LoopingVideoPlayer

	init(backgroundVideoPlayer: LoopingVideoPlayer) {
		self.backgroundVideoPlayer = backgroundVideoPlayer
	}
}

struct LandingSplashView: View {

	@State var viewModel: LandingSplashViewModel

	init(viewModel: LandingSplashViewModel) {
		_viewModel = State(wrappedValue: viewModel)
	}

	var body: some View {
		VStack(spacing: 20) {
			Spacer()
			logoButton()
			Spacer()
			loginButton().opacity(0.0)
			signUpButton().opacity(0.0)
		}
		.padding(30)
		.background {
			backgroundVideo()
				.ignoresSafeArea()
		}
	}

	private func logoButton() -> some View {
		VStack(spacing: 2) {
			VectorImage(name: "Logo")
				.frame(width: 100, height: 100)
			Text("Voyages")
				.textCase(.uppercase)
				.font(.custom(FontStyle.virginVoyagesBold.fontName, size: 26))
				.foregroundStyle(.white)
		}.opacity(viewModel.logoVisible ? 1 : 0)
			.onAppear {
				withAnimation(.easeIn(duration: viewModel.logoAnimationDurationInSeconds)) {
					viewModel.logoVisible = true
				}
			}
	}

	private func loginButton() -> some View {
		Button("Login") {
		}
		.buttonStyle(PrimaryButtonStyle())
	}

	private func signUpButton() -> some View {
		Button("Sign up") {
		}
		.buttonStyle(SecondaryButtonStyle())
	}

	private func backgroundVideo() -> some View {
		LoopingVideoPlayerView(player: viewModel.backgroundVideoPlayer)
	}
}

struct LandingSplashView_Previews: PreviewProvider {
	static var previews: some View {
		let url = Bundle.main.url(forResource: "Ocean Waves", withExtension: "mp4")!
		let backgroundVideoPlayer = LoopingVideoPlayer(asset: .init(url: url))
		LandingSplashView(viewModel: LandingSplashViewModel(backgroundVideoPlayer: backgroundVideoPlayer))
			.previewLayout(.sizeThatFits)
	}
}
