//
//  DownloadFolioInvoiceRequest.swift
//  Virgin Voyages
//
//  Created by Pajtim on 18.7.25.
//

import Foundation

struct DownloadFolioInvoiceRequest: AuthenticatedHTTPRequestProtocol {
    var reservationGuestId: String

    var path: String {
        return NetworkServiceEndpoint.downloadFolioInvoice
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        return [
            URLQueryItem(name: "reservationGuestId", value: self.reservationGuestId)
        ]
    }
}

extension NetworkServiceProtocol {
    func downloadFolioInvoice(reservationGuestId: String) async throws -> Data? {
        let request = DownloadFolioInvoiceRequest(reservationGuestId: reservationGuestId)
        return try await self.getRawData(request: request)
    }
}
