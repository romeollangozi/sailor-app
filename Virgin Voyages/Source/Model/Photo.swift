//
//  Photo.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/3/24.
//

import Foundation
import SwiftUI
import UIKit

struct Photo: Identifiable {
	var id = UUID()
	var url: URL
	
	struct Share: Identifiable {
		var id = UUID()
		var image: UIImage
	}
}

// MARK: Authentication

extension Authenticatable {
	func download(photo: Photo) async throws -> UIImage {
		var request = URLRequest(url: photo.url)
		request.addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
		let (data, _) = try await URLSession.shared.data(for: request)
		guard let image = UIImage(data: data) else {
			throw Endpoint.Error("Cannot decode image")
		}
		
		return image
	}
}

// MARK: Views

struct PhotoActivityView: UIViewControllerRepresentable {
	var share: Photo.Share

	func makeUIViewController(context: Context) -> UIActivityViewController {
		let controller = UIActivityViewController(activityItems: [share.image], applicationActivities: nil)
		return controller
	}

	func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {

	}
}
