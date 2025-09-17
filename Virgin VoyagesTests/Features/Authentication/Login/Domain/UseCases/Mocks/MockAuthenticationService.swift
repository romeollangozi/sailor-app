//
//  MockAuthenticationService.swift
//  Virgin VoyagesTests
//
//  Created by Abel Duarte on 8/27/24.
//

import Foundation
@testable import Virgin_Voyages

class MockAuthenticationService: AuthenticationServiceProtocol {

    
    var authenticationEventNotificationService: Virgin_Voyages.AuthenticationEventNotificationService
    var error: AuthenticationServiceError? = nil
    var isFetchingReservation: Bool = false
    var isSwitchingReservation: Bool = false
	var reservation: Virgin_Voyages.VoyageReservation?
    var loginResult: LoginResult
	
	var currentAccount: Virgin_Voyages.Token?
	
	var userProfile: Virgin_Voyages.Endpoint.GetUserProfile.Response?
	
	init(reservation: Virgin_Voyages.VoyageReservation? = nil,
		 currentAccount: Virgin_Voyages.Token? = nil,
		 userProfile: Virgin_Voyages.Endpoint.GetUserProfile.Response? = nil,
		 shouldThrowError: Bool = false,
         loginResult: LoginResult = .success,
		 errorToThrow: Error = VVDomainError.genericError,
         authenticationEventNotificationService:AuthenticationEventNotificationService = .init()) {
		self.reservation = reservation
		self.currentAccount = currentAccount
		self.userProfile = userProfile
		self.shouldThrowError = shouldThrowError
        self.loginResult = loginResult
		self.errorToThrow = errorToThrow
        self.authenticationEventNotificationService = authenticationEventNotificationService
	}

    func reloadOnlyTheCurrentSailor() async throws {
        
    }
    
    func isLoggedIn() -> Bool {
        return true
    }
    
	func currentSailor() throws -> Virgin_Voyages.Endpoint.SailorAuthentication {
		throw errorToThrow
	}
	
	func currentUser() throws -> Virgin_Voyages.Endpoint.UserAuthentication {
		throw errorToThrow
	}
	
	func clearReservation() {
        reservation = nil
	}
	
	func signOut() async {
	}
	
    func login(_ type: Virgin_Voyages.LoginType) async throws -> LoginResult {
        if shouldThrowError {
            throw errorToThrow
        }
        
        return loginResult
    }
    
    func finishLogin(account: Virgin_Voyages.Token) async throws {
        
    }
    

	func select(reservation: Virgin_Voyages.VoyageReservation) {
	}
	
	func select(booking: Virgin_Voyages.Endpoint.GetUserReservations.Response.GuestBooking) async throws {
	}
	
	func signUp(email: String,
				firstName: String,
				lastName: String,
				password: String,
				preferredName: String,
				birthDate: String,
				userType: String,
				enableEmailNewsOffer: Bool,
				isVerificationRequired: Bool) async -> Virgin_Voyages.SignUpCredentialsDetails? {
		return SignUpCredentialsDetails(signUpCredentialsDetails: TokenDTO(userType: "",
																		   refreshToken: "",
																		   tokenType: "",
																		   accessToken: "",
																		   expiresIn: 0,
																		   status: .active))
	}
	
	
    var shouldThrowError: Bool = false
    var errorToThrow: Error = VVDomainError.genericError
    
	var reloadedReservationNumber: String? = nil
	
    func reloadReservation(reservationNumber: String?, displayLoadingFlow: Bool) async throws {
        reloadedReservationNumber = reservationNumber
    }
    
    func setAssistingSailor(sailor: Virgin_Voyages.Sailor?) {
        
    }
    
    func userHasReservation() -> Bool {
        return self.reservation != nil
    }
}
