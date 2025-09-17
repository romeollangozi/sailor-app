//
//  UploadMediaRepository.swift
//  Virgin Voyages
//
//  Created by Pajtim on 12.3.25.
//

import Foundation

protocol UploadMediaRepositoryProtocol {
    func uploadMedia(imageData: Data) async throws -> String?
}

class UploadMediaRepository: UploadMediaRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }

    func uploadMedia(imageData: Data) async throws-> String? {
        try await networkService.uploadMedia(imageData: imageData)
    }
}
