//
//  CachedImageUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 5/7/25.
//

import Foundation

protocol CachedImageUseCaseProtocol {
	func fetchImage(from url: String) async -> Data
    func getCachedImage(from url: String) -> Data?
}

final class CachedImageUseCase: CachedImageUseCaseProtocol {
 

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
