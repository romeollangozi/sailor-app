//
//  ImageViewer.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 11.3.25.
//
import SwiftUI

public struct ImageViewer: View {
	@State private var isLoading: Bool
	@StateObject private var detector = ImageTypeDetector()

	let url: String
	let width: CGFloat
	let height: CGFloat
	let contentMode: ContentMode

	public init(isLoading: Bool = false, url: String, width: CGFloat = 60, height: CGFloat = 60, contentMode: ContentMode = .fill) {
		_isLoading = State(wrappedValue: isLoading)
		self.url = url
		self.width = width
		self.height = height
		self.contentMode = contentMode
	}

	public var body: some View {
		VStack {
			if let mimeType = detector.mimeType {
				if mimeType.contains("svg") {
					DynamicSVGImageLoader(url: URL(string: url)!, isLoading: $isLoading)
						.grayscale(0)
						.frame(width: width, height: height)
						.cornerRadius(6)
				} else {
					URLImage(url: URL(string: url), contentMode: contentMode)
						.grayscale(0)
						.frame(width: width, height: height)
						.cornerRadius(6)
				}
			} else {
				// Placeholder while detecting
				ProgressView()
					.frame(width: width, height: height)
					.onAppear {
						if let safeURL = URL(string: url) {
							detector.detectType(for: safeURL)
						}
					}
			}
		}
	}
}

class ImageTypeDetector: ObservableObject {
	@Published var mimeType: String? = nil

	func detectType(for url: URL) {
		var request = URLRequest(url: url)
		request.httpMethod = "GET"

		URLSession.shared.dataTask(with: request) { _, response, _ in
			if let httpResponse = response as? HTTPURLResponse,
			   let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type") {
				DispatchQueue.main.async {
					self.mimeType = contentType
				}
			}
		}.resume()
	}
}
