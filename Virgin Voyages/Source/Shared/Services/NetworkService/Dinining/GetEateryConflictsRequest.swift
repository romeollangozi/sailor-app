//
//  GetEateriesConflictsRequest.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 27.11.24.
//

struct GetEateryConflictsRequest: AuthenticatedHTTPRequestProtocol {
    let input: GetEateryConflictsRequestBody
    
    var path: String {
        return NetworkServiceEndpoint.eateriesConflicts
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

struct GetEateryConflictsRequestBody: Codable {
    struct PersonDetail: Codable {
        let personId: String
    }
    
    let personDetails: [PersonDetail]
    let activityCode: String
    let shipCode: String
    let activitySlotCode: String
    let startDateTime: String
    let endDateTime: String
    let activityGroupCode: String
    let isActivityPaid: Bool
    let bookingType: String
    let bookingLinkIds: [String]
    let embarkDate: String
    let debarkDate: String
}

struct GetEateryConflictsResponse: Codable {
    struct Details: Codable {
        struct PersonDetail: Codable {
            let personId: String?
            let count: Int?
        }
        
        let bookingStartDateTime: Int?
        let bookingActivityCode: String?
        let personDetails: [PersonDetail]?
        let cancellableRestaurantExternalId: String?
        let cancellableAppointmentDateTime: String?
        let cancellableBookingLinkId: String?
        let swappableRestaurantExternalId: String?
        let swappableAppointmentDateTime: String?
    }
    
    let isSwapped: Bool?
    let details: Details?
    let type: String?
}

extension NetworkServiceProtocol {
    func getEateryConflicts(request: GetEateryConflictsRequestBody) async throws -> GetEateryConflictsResponse? {
        let request = GetEateryConflictsRequest(input: request)
        return try await self.requestV2(request, responseModel: GetEateryConflictsResponse.self)
    }
}
