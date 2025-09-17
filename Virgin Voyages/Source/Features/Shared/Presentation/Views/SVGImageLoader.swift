//
//  SVGImageLoader.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.11.24.
//

import SwiftUI
import SVGKit

struct SVGImageView: View {
    let url: URL
    let frameSize: CGSize

    @State private var isLoading = true
    @State private var svgImage: SVGKImage? = nil

    init(url: URL,
		 frameSize: CGSize = CGSize(width: Sizes.defaultSize40,
									height: Sizes.defaultSize40),
		 isLoading: Bool = true,
		 svgImage: SVGKImage? = nil) {
        self.url = url
        self.frameSize = frameSize
        _isLoading = State(wrappedValue: isLoading)
        _svgImage = State(wrappedValue: svgImage)
    }
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let svgImage = svgImage {
                SVGImageLoader(svgImage: svgImage, frameSize: frameSize)
                    .frame(width: frameSize.width, height: frameSize.height)
            } else {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: frameSize.width, height: frameSize.height)
            }
        }
        .frame(width: frameSize.width, height: frameSize.height)
        .onAppear {
            loadSVGImage()
        }
    }

    private func loadSVGImage() {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = SVGKImage(data: data) {
                    DispatchQueue.main.async {
                        image.size = frameSize
                        self.svgImage = image
                        self.isLoading = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
}

struct SVGImageLoader: UIViewRepresentable {
    let svgImage: SVGKImage
    let frameSize: CGSize

    func makeUIView(context: Context) -> SVGKFastImageView {
        let imageView = SVGKFastImageView(svgkImage: svgImage) ?? SVGKFastImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func updateUIView(_ uiView: SVGKFastImageView, context: Context) {
        uiView.image = svgImage
        uiView.frame = CGRect(origin: .zero, size: frameSize)
    }
}
