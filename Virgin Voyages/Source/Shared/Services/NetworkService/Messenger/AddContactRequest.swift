//
//  AddContactRequest.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.11.24.
//

struct AddContactRequest: AuthenticatedHTTPRequestProtocol {
    let input: AddContactRequestBody
    
    var path: String {
        return NetworkServiceEndpoint.addContact
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

struct AddContactRequestBody : Codable {
    let personId: String
    let connectionPersonId: String
    let isEventVisibleCabinMates: Bool
}

struct AddContactResponse: Decodable {
    init() {}
}

extension NetworkServiceProtocol {
    func addContact(request: AddContactRequestBody) async -> ApiResponse<AddContactResponse> {
        let request = AddContactRequest(input: request)
        return await self.request(request, responseModel: AddContactResponse.self)
    }
}
