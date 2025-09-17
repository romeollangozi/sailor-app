//
//  GetAppleWalletBoardingPassRequest.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/10/25.
//

import Foundation

struct GetAppleWalletBoardingPassRequest: AuthenticatedHTTPRequestProtocol {
    
    var reservationGuestId: String
    
    var path: String {
        return NetworkServiceEndpoint.getAppleWalletForBoardingPass + "/\(reservationGuestId)"
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
}

extension NetworkServiceProtocol {
    
    func getBoardingPassAppleWallet(reservationGuestId: String) async throws -> Data? {
        let request = GetAppleWalletBoardingPassRequest(reservationGuestId: reservationGuestId)
        return try await self.getRawData(request: request)
    }
}
