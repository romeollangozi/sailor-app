//
//  DownloadImageUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 25.10.24.
//

import Foundation

protocol DownloadImageUseCaseProtocol {
    func downloadFile(filURL: String) async -> Data?
}

class DownloadImageUseCase: DownloadImageUseCaseProtocol {
    
    // MARK: - Properties
    private let downloadFileRepository: FileRepositoryProtocol
    
    // MARK: - Init
    init(downloadFileRepository: FileRepositoryProtocol = FileRepository()) {
        self.downloadFileRepository = downloadFileRepository
    }
    
    // MARK: - Download file
    func downloadFile(filURL: String) async -> Data? {
        let result = await self.downloadFileRepository.downloadFile(fileURL: filURL)
        switch result {
        case .success(let data):
            guard let fileData = data else { return nil }
            return fileData
        case .failure:
            return nil
        }
    }
}
