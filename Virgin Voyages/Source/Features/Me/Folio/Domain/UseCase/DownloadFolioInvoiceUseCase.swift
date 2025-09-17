//
//  DownloadFolioInvoiceUseCase.swift
//  Virgin Voyages
//
//  Created by Pajtim on 18.7.25.
//

import Foundation

protocol DownloadFolioInvoiceUseCaseProtocol {
    func execute() async throws -> Data
}

final class DownloadFolioInvoiceUseCase: DownloadFolioInvoiceUseCaseProtocol {
    private let downloadFolioInvoiceRepository: DownloadFolioInvoiceRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol

    init(downloadFolioInvoiceRepository: DownloadFolioInvoiceRepositoryProtocol = DownloadFolioInvoiceRepository(), currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.downloadFolioInvoiceRepository = downloadFolioInvoiceRepository
        self.currentSailorManager = currentSailorManager
    }

    func execute() async throws -> Data {
        guard let sailor = currentSailorManager.getCurrentSailor() else {
            throw VVDomainError.unauthorized
        }

        guard let response = try await downloadFolioInvoiceRepository.downloadFolioInvoice(reservationGuestId: sailor.reservationGuestId) else {
            throw VVDomainError.genericError
        }
        return response
    }
}
