//
//  MockDownloadFolioInvoiceRepository.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 18.7.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockDownloadFolioInvoiceRepository: DownloadFolioInvoiceRepositoryProtocol {
    var expectedData: Data?

    func downloadFolioInvoice(reservationGuestId: String) async throws -> Data? {
        return expectedData
    }
}
