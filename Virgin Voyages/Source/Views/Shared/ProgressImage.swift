//
//  ProgressImage.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/14/23.
//

import SwiftUI
import VVUIKit

struct ContainerRelativeFrameModifier: ViewModifier {
	var widthPercentage: Double
	var heightPercentage: Double
	func body(content: Content) -> some View {
		content
			.containerRelativeFrame(.horizontal) { length, axis in
				length * widthPercentage
			}
			.containerRelativeFrame(.vertical) { length, axis in
				length * heightPercentage
			}
			.clipped()
	}
}

extension View {
	func containerRelativeFrame(widthPercentage: Double, heightPercentage: Double) -> some View {
		modifier(ContainerRelativeFrameModifier(widthPercentage: widthPercentage, heightPercentage: heightPercentage))
	}
}

struct BackgroundImageModifier: ViewModifier {
	var url: URL?

	func body(content: Content) -> some View {
		content
			.background {
				if let url {
					AsyncImage(url: url) { image in
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(minWidth: 0, maxWidth: .infinity)
							.ignoresSafeArea()
					} placeholder: {
						ProgressView()
					}
				}
			}
	}
}

extension View {
	func background(url: URL?) -> some View {
		self.modifier(BackgroundImageModifier(url: url))
	}
}

struct AuthenticatedProgressImage: View {
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
	var url: URL
	var aspectRatio: CGFloat?
	var contentMode: ContentMode = .fill
	var cornerRadius: CGFloat?
	@State private var image: Image?
	
	var body: some View {
		ZStack {
			ProgressView()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.cornerRadius(cornerRadius ?? 0)
				.task {
					Task {
						let uiImage = try await authenticationService.currentUser().download(photo: Photo(url: url))
						image = Image(uiImage: uiImage)
					}
				}

			if let image {
				image
					.resizable()
					.aspectRatio(aspectRatio, contentMode: contentMode)
					.cornerRadius(cornerRadius ?? 0)
			}
		}
		.animation(.easeInOut, value: image)
	}
}

#Preview {
	ProgressImage(url: URL(string: "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:91d9ef3c-0df8-4473-8972-2d3054b5dafc/breakpoint%20mobile%20new.jpg")!)
		.containerRelativeFrame(widthPercentage: 0.75, heightPercentage: 0.5)
}
