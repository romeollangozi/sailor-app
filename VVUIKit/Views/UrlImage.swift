//
//  RemoteImage.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.2.25.
//

import SwiftUI


public struct URLImage: View {
    var url: URL?
    var contentMode: ContentMode

    public init(url: URL? = nil, contentMode: ContentMode = .fill) {
		self.url = url
        self.contentMode = contentMode
	}

    public var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } placeholder: {
            if url != nil {
                ProgressView()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .aspectRatio(contentMode: contentMode)
            }
        }
    }
}

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

#Preview {
    URLImage(url: URL(string: "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:91d9ef3c-0df8-4473-8972-2d3054b5dafc/breakpoint%20mobile%20new.jpg")!)
        .containerRelativeFrame(widthPercentage: 0.75, heightPercentage: 0.5)
}
