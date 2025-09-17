//
//  UploadPhotoUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 11.9.24.
//

import Foundation

// MARK: - Typealias
public typealias UploadPhotoResonseType = (photoURL: String?, status: Bool)

class UploadPhotoUseCase {
    // MARK: - Private properties
	private var service: NetworkServiceProtocol

    // MARK: - Init
    init(service: NetworkServiceProtocol = NetworkService.create()) {
        self.service = service
    }
    
    // MARK: - Execute
    func execute(model: SignUpInputModel, token: String) async -> UploadPhotoResonseType {
        guard let imageData = model.imageData else {
            return UploadPhotoResonseType(photoURL: nil, status: false)
        }
        if let photoURL = await service.uploadPhoto(imageData: imageData, token: token) {
            return UploadPhotoResonseType(photoURL: photoURL, status: true)
        } else {
            return UploadPhotoResonseType(photoURL: nil, status: false)
        }
    }
}
