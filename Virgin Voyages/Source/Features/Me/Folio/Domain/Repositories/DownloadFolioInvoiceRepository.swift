//
//  DownloadFolioInvoiceRepository.swift
//  Virgin Voyages
//
//  Created by Pajtim on 18.7.25.
//

import Foundation

protocol DownloadFolioInvoiceRepositoryProtocol {
    func downloadFolioInvoice(reservationGuestId: String) async throws -> Data?
}

final class DownloadFolioInvoiceRepository: DownloadFolioInvoiceRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func downloadFolioInvoice(reservationGuestId: String) async throws -> Data? {
        return try await networkService.downloadFolioInvoice(reservationGuestId: reservationGuestId)
    }
}
