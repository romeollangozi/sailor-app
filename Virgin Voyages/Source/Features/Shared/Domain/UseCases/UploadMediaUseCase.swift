//
//  UploadMediaUseCase.swift
//  Virgin Voyages
//
//  Created by Pajtim on 12.3.25.
//

import Foundation

protocol UploadMediaUseCaseProtocol {
    func execute(imageData: Data) async throws -> String?
}

class UploadMediaUseCase: UploadMediaUseCaseProtocol {
    private let uploadMediaRepository: UploadMediaRepositoryProtocol

    init(uploadMediaRepository: UploadMediaRepositoryProtocol = UploadMediaRepository()) {
        self.uploadMediaRepository = uploadMediaRepository
    }

    func execute(imageData: Data) async throws -> String? {
        try await uploadMediaRepository.uploadMedia(imageData: imageData)
    }
}
