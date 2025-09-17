//
//  TestData.swift
//  Virgin Voyages
//
//  Created by TX on 27.8.25.
//

import XCTest
@testable import Virgin_Voyages

// MARK: - Common test data
extension AuthenticationServiceTests {
    enum TestData {
        static var dummyToken: Token {
            Token(
                refreshToken: "r_tok",
                tokenType: "Bearer",
                accessToken: "a_tok",
                expiresIn: 3600,
                status: .active
            )
        }
        
        // Minimal, valid-ish UserProfile to pass around in tests
        static var dummyUserProfile: Endpoint.GetUserProfile.Response {
            .init(
                genderCode: nil,
                lastName: "Doe",
                firstName: "Jane",
                birthDate: "01-01-2000",
                isPasswordExist: true,
                personId: "pid",
                hasLinkedReservations: false,
                personTypeCode: "G",
                emailVerificationStatus: nil,
                phoneCountryCode: nil,
                photoUrl: "",
                email: "jane@example.com",
                phoneNumber: nil,
                bookingInfo: nil,
                userNotifications: []
            )
        }
    }
}
