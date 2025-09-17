//
//  DownloadImageViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 25.10.24.
//

import Foundation
import VVUIKit

@Observable
final class DownloadImageViewModel: DownloadImageViewModelProtocol {
    
    private let fileURL: String
    
    var imageData: Data?
    var isLoading: Bool = false
    
    private let cachedImageUseCase: CachedImageUseCaseProtocol

    init(cachedImageUseCase: CachedImageUseCaseProtocol = CachedImageUseCase(),
         fileURL: String) {
        self.cachedImageUseCase = cachedImageUseCase
        self.fileURL = fileURL
        self.imageData = cachedImageUseCase.getCachedImage(from: self.fileURL)
        if self.imageData == nil {
            isLoading = true
        }
    }

    
	func downloadFile() async {
		let data = await cachedImageUseCase.fetchImage(from: fileURL)

		await MainActor.run {
			imageData = data
			isLoading = false
		}
	}
}
