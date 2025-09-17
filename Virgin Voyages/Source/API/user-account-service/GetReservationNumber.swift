//
//  GetReservationNumber.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/28/24.
//

import Foundation

extension Endpoint {
    struct GetReservationNumber: Requestable {
        typealias RequestType = Request
        typealias QueryType = NoQuery
        typealias ResponseType = Response
        var authenticationType: AuthenticationType = .basic
        var path = "/user-account-service/signin/reservationNumber"
        var method: Method = .post
        var cachePolicy: CachePolicy = .none
        var scope: RequestScope = .shipOnly
        var pathComponent: String?
        var request: Request?
        var query: NoQuery?
        private let recaptchaToken: String?

        init(lastName: String, birthDate: Date, sailDate: Date, reservationNumber: String, reservationGuestId: String? = nil, recaptchaToken: String? = nil) {
            self.recaptchaToken = recaptchaToken

            // 53f6f920-4901-4c2a-9109-2ff80e9feca4
            request = .init(lastName: lastName,
                            birthDate: birthDate.format(.iso8601date),
                            sailDate: sailDate.format(.iso8601date), 
                            reservationNumber: reservationNumber,
                            reservationGuestId: reservationGuestId,
                            action: "signInReservationNumber")
        }

        // reCAPTCHA Token headers
        var customHeaders: [String: String]? {
            guard let recaptchaToken = recaptchaToken else { return nil }
            return [
                "VV-ReCaptchaToken": recaptchaToken,
                "VV-UserAgent": "ios"
            ]
        }
        
        // MARK: Request Data
        
        struct Request: Encodable {
            let lastName: String // Desalvo
            let birthDate: String // YYYY-MM-DD
            let sailDate: String
            let reservationNumber: String
            let reservationGuestId: String?
            let action: String

            enum CodingKeys: String, CodingKey {
                case lastName
                case birthDate
                case sailDate
                case reservationNumber
                case reservationGuestId
                case action
            }
        }

		struct Response: Codable {
            let accessToken: String? // Token value
            let bearerType: String? // bearer
            let refreshToken: String? // Refresh token value
            let expiresIn: Int? // 2591999
            let scope: String? // read trust write
            let companyId: String? // b35a325a-036a-4ad4-8836-646923e601de
            let userGUID: String? // 0a7da173-a785-416a-a14e-38515f222401
            let authenticationMethod: String? // CabinLoginAuthenticationToken
            let roles: [String]? // Empty array
            let userType: String? // guest
            let personId: String? // e1c8e6be-b183-46a9-86b7-c46fb1ae2eb7
            let isTemporary: Bool? // null
            let id: String? // 0a7da173-a785-416a-a14e-38515f222401
            let tokenType: String? // userToken
            let userid: String? // 0a7da173-a785-416a-a14e-38515f222401
            let jti: String? // 5df8fbfa-3b3b-4091-b158-5304813aecf4
			let status: AccountStatusDTO?
            let guestDetails: [GuestDetail]?
            
            struct GuestDetail: Codable {
                let name: String?
                let birthDate: String?
                let reservationGuestId: String?
                let profilePhotoUrl: String?
                let reservationNumber: String?
                let lastName: String?
            }

            enum CodingKeys: String, CodingKey {
                case accessToken = "access_token"
                case bearerType = "token_type"
                case refreshToken = "refresh_token"
                case expiresIn = "expires_in"
                case scope
                case companyId
                case userGUID
                case authenticationMethod
                case roles
                case userType
                case personId
                case isTemporary
                case id
                case tokenType = "tokenType"
                case userid
                case jti
				case status
                case guestDetails
            }
        }
    }
}

extension Endpoint.GetReservationNumber.Response {
    public static func mock() -> Endpoint.GetReservationNumber.Response {
        .init(
            accessToken: "",
            bearerType: "",
            refreshToken: nil,
            expiresIn: 0,
            scope: "",
            companyId: nil,
            userGUID: "",
            authenticationMethod: "",
            roles: [],
            userType: nil,
            personId: "",
            isTemporary: nil,
            id: "",
            tokenType: "",
            userid: "",
            jti: "",
            status: AccountStatusDTO.active,
            guestDetails: [
                GuestDetail(
                    name: "John",
                    birthDate: "2001-01-01",
                    reservationGuestId: "00000000-0000-0000-0000-000000000001",
                    profilePhotoUrl: nil,
                    reservationNumber: "123456",
                    lastName: "Doe"
                ),
                GuestDetail(
                    name: "Jane",
                    birthDate: "2001-01-01",
                    reservationGuestId: "00000000-0000-0000-0000-000000000002",
                    profilePhotoUrl: nil,
                    reservationNumber: "654321",
                    lastName: "Smith"
                )
            ]
        )
    }
}
