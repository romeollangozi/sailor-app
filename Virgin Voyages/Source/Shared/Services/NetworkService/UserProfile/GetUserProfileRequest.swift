//
//  GetUserProfileRequest.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 29.10.24.
//

struct GetUserProfileRequest: AuthenticatedHTTPRequestProtocol {
    var path: String {
        return NetworkServiceEndpoint.getUserProfile
    }
    var method: HTTPMethod {
        return .GET
    }
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
}

struct GetUserProfileResponse: Decodable {
    let firstName: String?
    let lastName: String?
    let photoUrl: String?
    let bookingInfo: BookingInfo?
    let birthDate: String?
    let phoneCountryCode: String?
    let userNotifications: [UserNotification]?
    let email: String?
    let isPasswordExist: Bool?
    let personId: String?
    let personTypeCode: String?
    let hasLinkedReservations: Bool?
    let emailVerificationStatus: String?
    let citizenshipCountryCode: String?
    let preferredName: String?
    
    struct BookingInfo: Codable {
        let embarkDate: String?
        let reservationNumber: String?
        let guestId: String?
        let reservationGuestId: String?
        let status: String?
        let isVIP: Bool?
        let guestTypeCode: String?
    }
    
    struct UserNotification: Codable {
        let userNotificationId: String?
        let userGUID: String?
        let userId: String?
        let notificationTypeCode: String?
        let isOptInForSMS: Bool?
        let isOptInForCall: Bool?
        let isOptInForEmail: Bool?
        let isDeleted: Bool?
        
        enum CodingKeys: String, CodingKey {
            case userNotificationId
            case userGUID
            case userId
            case notificationTypeCode
            case isOptInForSMS = "IsOptInForSMS"
            case isOptInForCall = "IsOptInForCall"
            case isOptInForEmail = "IsOptInForEmail"
            case isDeleted
        }
    }
}

extension NetworkServiceProtocol {
    func getUserProfile() async throws -> GetUserProfileResponse? {
        let request = GetUserProfileRequest()
        return try await self.requestV2(request, responseModel: GetUserProfileResponse.self)
    }
}
