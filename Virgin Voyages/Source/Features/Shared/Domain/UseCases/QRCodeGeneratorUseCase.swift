//
//  QRCodeGeneratorUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 28.10.24.
//

import SwiftUI

protocol QRGeneratorUseCaseProtocol {
    func execute(input: String) -> Data
}

class QRGeneratorUseCase: QRGeneratorUseCaseProtocol {
    
    private let repository: QRCodeGeneratorRepositoryProtocol
    
    init(repository: QRCodeGeneratorRepositoryProtocol = QRCodeGeneratorRepository()) {
        self.repository = repository
    }
    
    func execute(input: String) -> Data {
        if let qrCode = repository.generateQRCode(input: input) {
            return qrCode
        }else {
            return Data()
        }
    }
}
