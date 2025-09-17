//
//  QRCodeGeneratorRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 28.10.24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins


protocol QRCodeGeneratorRepositoryProtocol {
    func generateQRCode(input: String) -> Data?
}

class QRCodeGeneratorRepository: QRCodeGeneratorRepositoryProtocol {
    
    // MARK: - Properties
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    
    // MARK: - GenerateQRCode
    func generateQRCode(input: String) -> Data? {
        let data = Data(input.utf8)
        let size: CGSize = CGSize(width: 300, height: 300)
        let filter = CIFilter.qrCodeGenerator()
        filter.message = data
        
        if let outputImage = filter.outputImage {
            let scaleX = size.width / outputImage.extent.size.width
            let scaleY = size.height / outputImage.extent.size.height
            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            
            let context = CIContext()
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage).pngData()
            }
        }
        return nil
    }
}
