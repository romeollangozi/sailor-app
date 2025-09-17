//
//  AddFriendRequest.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 30.10.24.
//

struct AddOrRemoveFriendRequest: AuthenticatedHTTPRequestProtocol {
    let input: AddOrRemoveFriendRequestBody
    
    var path: String {
        return NetworkServiceEndpoint.addFriendToContacts
    }
    
    var method: HTTPMethod {
        return .POST
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
        
    var bodyCodable: (any Codable)? {
        return input
    }
}

struct AddOrRemoveFriendRequestBody : Codable {
    let isDeleted: Bool
    let reservationId: String
    let personId: String
    let connectionPersonId: String
    let connectionReservationId: String
}


extension NetworkServiceProtocol {
    func addOrRemoveFriendFromContacts(request: AddOrRemoveFriendRequestBody) async throws  -> EmptyResponse? {
        let request = AddOrRemoveFriendRequest(input: request)
        return try await self.requestV2(request, responseModel: EmptyResponse.self)
    }
}
