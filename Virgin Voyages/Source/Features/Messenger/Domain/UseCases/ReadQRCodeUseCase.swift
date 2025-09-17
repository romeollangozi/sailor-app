//
//  ReadQRCodeUseCase.swift
//  Virgin Voyages
//
//  Created by Pajtim on 22.1.25.
//

import Foundation
import CoreImage

protocol ReadQRCodeUseCaseProtocol {
    func execute(with ciImage: CIImage) -> Result<String, VVDomainError>
}

class ReadQRCodeUseCase: ReadQRCodeUseCaseProtocol {
    private let scannerService: ReadQRCodeServiceProtocol

    init(scannerService: ReadQRCodeServiceProtocol = ReadQRCodeService()) {
        self.scannerService = scannerService
    }

    func execute(with ciImage: CIImage) -> Result<String, VVDomainError> {
        scannerService.readQRCode(from: ciImage)
    }
}
