//
//  ProgressImage.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/7/25.
//

import SwiftUI

public struct ProgressImage: View {
	public var url: URL?
	@State private var viewModel = ProgressImageViewModel(url: nil)

	public init(url: URL? = nil) {
		self.url = url
        _viewModel = .init(wrappedValue: ProgressImageViewModel(url: url))
	}

	public var body: some View {
		ZStack {
			if let image = viewModel.image {
				Image(uiImage: image)
					.resizable()
					.aspectRatio(contentMode: .fill)
			} else if viewModel.isLoading {
				ProgressView()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.aspectRatio(contentMode: .fill)
			}
		}
		.onAppear {
			viewModel.load(url: url)
		}
	}
}

@MainActor
@Observable
fileprivate final class ProgressImageViewModel {
	var image: UIImage?
	var isLoading = false

	private let useCase: CachedImageUseCaseProtocol

	init(useCase: CachedImageUseCaseProtocol = CachedImageUseCase(), url: URL?) {
		self.useCase = useCase
        if let url, let data = self.useCase.getCachedImage(from: url.absoluteString) {
            if let uiImage = UIImage(data: data) {
                self.image = uiImage
            }
        }
	}

	func load(url: URL?) {
		guard let url else { return }

		Task {
            if self.image == nil {
                isLoading = true
            }
            let data = await useCase.fetchImage(from: url.absoluteString)
            if let uiImage = UIImage(data: data) {
                self.image = uiImage
            }
            self.isLoading = false
		}
	}
}

fileprivate protocol CachedImageUseCaseProtocol {
	func fetchImage(from url: String) async -> Data
    func getCachedImage(from url: String) -> Data?
}

fileprivate final class CachedImageUseCase: CachedImageUseCaseProtocol {

	private let fileManager = FileManager.default
	private let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
	private let downloadImageUseCase: DownloadImageUseCaseProtocol

	init(downloadImageUseCase: DownloadImageUseCaseProtocol = DownloadImageUseCase()) {
		self.downloadImageUseCase = downloadImageUseCase
	}

	func fetchImage(from url: String) async -> Data {
		let cacheFile = cacheDirectory.appendingPathComponent(cacheKey(for: url))

		if let cachedData = try? Data(contentsOf: cacheFile) {
			Task {
				await refreshCache(for: url, at: cacheFile)
			}
			return cachedData
		}

		return await downloadAndCache(from: url, to: cacheFile)
	}
    
    func getCachedImage(from url: String) -> Data? {
        let cacheFile = cacheDirectory.appendingPathComponent(cacheKey(for: url))

        if let cachedData = try? Data(contentsOf: cacheFile) {
            return cachedData
        }
        return nil
    }

	private func refreshCache(for url: String, at path: URL) async {
		_ = await downloadAndCache(from: url, to: path)
	}

	private func downloadAndCache(from url: String, to path: URL) async -> Data {
		if let data = await downloadImageUseCase.downloadFile(filURL: url), data.count > 0 {
			try? data.write(to: path, options: .atomic)
			return data
		}
		return Data()
	}

	private func cacheKey(for url: String) -> String {
		return url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? UUID().uuidString
	}
}

fileprivate protocol DownloadImageUseCaseProtocol {
	func downloadFile(filURL: String) async -> Data?
}

fileprivate class DownloadImageUseCase: DownloadImageUseCaseProtocol {

	// MARK: - Properties
	private let downloadFileRepository: FileRepositoryProtocol

	// MARK: - Init
	init(downloadFileRepository: FileRepositoryProtocol = FileRepository()) {
		self.downloadFileRepository = downloadFileRepository
	}

	// MARK: - Download file
	func downloadFile(filURL: String) async -> Data? {
		let result = await self.downloadFileRepository.downloadFile(fileURL: filURL)
		return result
	}
}

fileprivate protocol FileRepositoryProtocol {
	func downloadFile(fileURL: String) async -> Data?
}

fileprivate class FileRepository: FileRepositoryProtocol {

	func downloadFile(fileURL: String) async -> Data? {
		guard let url = URL(string: fileURL) else {
			return nil
		}

		var request = URLRequest(url: url)
		request.httpMethod = "GET"

		do {
			let (data, response) = try await URLSession.shared.data(for: request)

			guard let httpResponse = response as? HTTPURLResponse,
				  200..<300 ~= httpResponse.statusCode else {
				return nil
			}

			return data
		} catch {
			return nil
		}
	}
}
