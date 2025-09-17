//
//  QRCodeViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 28.10.24.
//

import SwiftUI

protocol VVQRCodeViewModelProtocol {
    var profileImage: String? { get set }
    func generateQRCode() -> Data
}

@Observable class VVQRCodeViewModel: VVQRCodeViewModelProtocol {
    
    private let useCase: QRGeneratorUseCaseProtocol
    private var input: String
    var profileImage: String?
    
    init(useCase: QRGeneratorUseCaseProtocol = QRGeneratorUseCase(), input: String = "", profileImage: String? = nil) {
        self.useCase = useCase
        self.input = input
        self.profileImage = profileImage
    }
    
    func generateQRCode() -> Data {
        return useCase.execute(input: input)
    }
}
