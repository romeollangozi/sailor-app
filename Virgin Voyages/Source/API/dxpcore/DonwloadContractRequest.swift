//
//  DonwloadContractRequest.swift
//  Virgin Voyages
//
//  Created by Pajtim on 29.11.24.
//

import Foundation

extension Endpoint {
    struct DonwloadContractRequest: Requestable {
        typealias RequestType = NoRequest
        typealias QueryType = Query
        typealias ResponseType = Data
        var authenticationType: AuthenticationType = .user
        var path = "/dxpcore/downloadcontract"
        var method: Endpoint.Method = .get
        var cachePolicy: Endpoint.CachePolicy = .always
        var scope: RequestScope = .any
        var pathComponent: String?
        var request: NoRequest?
        var query: Query?

        init(contractId: String, reservationGuestId: String, version: String) {
            let contractType = "VC"
            query = .init(contractType: contractType, contractId: contractId, reservationGuestId: reservationGuestId, version: version)
        }

        struct Query: Encodable {
            var contractType: String
            var contractId: String
            var reservationGuestId: String
            var version: String
        }
    }
}
