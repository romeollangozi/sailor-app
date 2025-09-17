//
//  ReadQRCodeService.swift
//  Virgin Voyages
//
//  Created by Pajtim on 21.1.25.
//

import CoreImage

protocol ReadQRCodeServiceProtocol {
    func readQRCode(from ciImage: CIImage) -> Result<String, VVDomainError>
}

class ReadQRCodeService: ReadQRCodeServiceProtocol {
    func readQRCode(from ciImage: CIImage) -> Result<String, VVDomainError> {
        guard let detector = CIDetector(
            ofType: CIDetectorTypeQRCode,
            context: nil,
            options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        ) else {
            return .failure(.genericError)
        }

        let features = detector.features(in: ciImage)
        let qrCodeFeatures = features.compactMap { $0 as? CIQRCodeFeature }
        guard let qrCode = qrCodeFeatures.first?.messageString else {
            return .failure(.genericError)
        }

        return .success(qrCode)
    }
}
