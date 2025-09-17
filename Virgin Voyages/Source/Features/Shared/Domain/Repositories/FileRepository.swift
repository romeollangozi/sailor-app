//
//  FileRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 25.10.24.
//

import Foundation

protocol FileRepositoryProtocol {
    func downloadFile(fileURL: String) async -> Result<Data?, VVDomainError>
}

class FileRepository: FileRepositoryProtocol {

    // MARK: - Properties
    private let netoworkService: NetworkServiceProtocol
    
    // MARK: - Init
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.netoworkService = networkService
    }
    
    // MARK: - Download file
    func downloadFile(fileURL: String) async -> Result<Data?, VVDomainError> {
        let result = await netoworkService.downloadFile(fileURL: fileURL)
        if let error = result.error {
            return .failure(NetworkToVVDomainErrorMapper.map(from: error))
        }else {
            guard let responseData = result.response as? Data else {
                return .failure(.genericError)
            }
            return .success(responseData)
        }
    }
}
