//
//  ClaimBookingRequest.swift
//  Virgin Voyages
//
//  Created by TX on 14.7.25.
//


struct ClaimBookingRequest: AuthenticatedHTTPRequestProtocol {
	let input: ClaimBookingRequestBody

	var path: String {
        return NetworkServiceEndpoint.claimBooking
	}

	var method: HTTPMethod {
		return .POST
	}

	var headers: (any HTTPHeadersProtocol)? {
        if input.recaptchaToken.isEmpty { // Not all claim a booking entry points require recaptcha
            JSONContentTypeHeader()
        } else {
            ClaimBookingRequest.Headers(recaptchaToken: input.recaptchaToken)
        }
	}

	var bodyCodable: (any Codable)? {
		return input
	}
}

extension ClaimBookingRequest {
    struct Headers: HTTPHeadersProtocol {

        let recaptchaToken: String
        init(recaptchaToken: String) {
            self.recaptchaToken = recaptchaToken
        }

        var headers: [String: String?] {
            var allHeaders = JSONContentTypeHeader().headers
            allHeaders["VV-UserAgent"] = "ios"
            allHeaders["VV-ReCaptchaToken"] = recaptchaToken
            return allHeaders
        }
    }
}

struct ClaimBookingRequestBody: Codable {
	let lastName: String
	let reservationNumber: String
	let birthDate: String
	let emailId: String?
	let reservationGuestId: String?
	let returnAllGuests: Bool
    let recaptchaToken: String

	enum CodingKeys: String, CodingKey {
		case lastName
		case reservationNumber
		case birthDate
		case emailId
		case reservationGuestId
        case recaptchaToken
		case returnAllGuests = "return-all-guests"
	}
}

struct ClaimBookingResponse: Decodable {
    let status: Status?
    let response: InnerResponse?

    struct InnerResponse: Decodable {
        let guestDetails: [GuestDetails]?
    }

    struct GuestDetails: Codable {
        let name: String?
        let lastName: String?
        let email: String?
        let birthDate: String?
        let reservationNumber: String?
        let reservationGuestId: String?
        let genderCode: String?
    }

    enum Status: String, Decodable {
        case success = "SUCCESS"
        case bookingNotFound = "GUEST_NOT_FOUND"
        case emailConflict = "EMAIL_CONFLICT"
        case guestConflict = "GUEST_CONFLICT"
        case unknown

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            self = Status(rawValue: rawValue) ?? .unknown
        }
    }
}


extension NetworkServiceProtocol {
    func claimBooking(request: ClaimBookingRequestBody) async throws -> ClaimBookingResponse? {
        let request = ClaimBookingRequest(input: request)
        return try await self.requestV2(request, responseModel: ClaimBookingResponse.self)
    }
}
