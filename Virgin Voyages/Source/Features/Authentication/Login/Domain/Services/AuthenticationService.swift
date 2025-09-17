//
//  AuthenticationService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/22/24.
//

import Foundation
import AuthenticationServices
import SwiftUI
import Network
import NetworkExtension
import CoreLocation
import Observation

enum AuthenticationServiceError: VVError {
    case domainError(VVDomainError)
    case systemError(Error)
}

protocol AuthenticationServiceProtocol {

    var authenticationEventNotificationService: AuthenticationEventNotificationService { get }
	func isLoggedIn() -> Bool
    func userHasReservation() -> Bool
    var error: AuthenticationServiceError? { get set }
    
	@discardableResult func login(_ type: LoginType) async throws -> LoginResult
	func signOut() async

	func signUp(email: String,
				firstName: String,
				lastName: String,
				password: String,
				preferredName: String,
				birthDate: String,
				userType: String,
				enableEmailNewsOffer: Bool,
				isVerificationRequired: Bool) async -> SignUpCredentialsDetails?

	func reloadReservation(reservationNumber: String?, displayLoadingFlow: Bool) async throws
	func reloadOnlyTheCurrentSailor() async throws

	var isFetchingReservation: Bool { get }
	var isSwitchingReservation: Bool { get }

	/* Legacy ModelData / To Be Refactored */
	var reservation: VoyageReservation? { get set }
	var currentAccount: Token? { get set }
	var userProfile: Endpoint.GetUserProfile.Response? { get set }

	func currentSailor() throws -> Endpoint.SailorAuthentication
	func currentUser() throws -> Endpoint.UserAuthentication
	func finishLogin(account: Token) async throws
	func select(reservation: VoyageReservation)

	func setAssistingSailor(sailor: Sailor?)
	/* End legacy ModelData */
}



class AuthenticationService: AuthenticationServiceProtocol {
	func isLoggedIn() -> Bool {
		return (currentAccount != nil)
	}
    
    func userHasReservation() -> Bool {
        return (reservation != nil)
    }

	/* Legacy ModelData properties (To be refactored) */
	var reservation: VoyageReservation?
	var currentAccount: Token?
	var userProfile: Endpoint.GetUserProfile.Response?
	var tokenRepository: TokenRepositoryProtocol
	var currentSailorManager: CurrentSailorManagerProtocol
    var reservationRepository: ReservationsRepositoryProtocol
	/* End legacy ModelData */

	static let shared = AuthenticationService()

	// State properties:
	var isFetchingReservation: Bool = false
	var isSwitchingReservation: Bool = false
    var error: AuthenticationServiceError? = nil
    var authenticationEventNotificationService: AuthenticationEventNotificationService

    private init(
        tokenRepository: TokenRepositoryProtocol = TokenRepository(),
        currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
        reservationRepository: ReservationsRepositoryProtocol = ReservationsRepository(),
        authenticationEventNotificationService: AuthenticationEventNotificationService = .shared
    ) {
        self.tokenRepository = tokenRepository
        self.currentSailorManager = currentSailorManager
        self.reservationRepository = reservationRepository
        self.authenticationEventNotificationService = authenticationEventNotificationService
        self.loadCurrentAccount()
        self.preloadReservation()
    }
    
    private func loadCurrentAccount() {
        print("AuthenticationService - loadCurrentAccount")
        // setup account
        guard let account = tokenRepository.getToken() else {
            return
        }
        currentAccount = account
    }

	@discardableResult func login(_ type: LoginType) async throws -> LoginResult {
		switch type {
		case .email(let email, let password):
			try await login(email: email, password: password)
		case .cabin(let cabinNumber, let lastName, let birthday, let reservationGuestId):
            return try await login(cabinNumber: cabinNumber, lastName: lastName, birthday: birthday, reservationGuestId: reservationGuestId)
		case .reservation(let lastName, let reservationNumber, let birthDate, let sailDate, let reservationGuestId, let recaptchaToken):
            return try await login(lastName: lastName, reservationNumber: reservationNumber, birthDate: birthDate, sailDate: sailDate, reservationGuestId: reservationGuestId, recaptchaToken: recaptchaToken)
		case .social(let socialMediaId, let type):
			return await login(socialMediaId: socialMediaId, type: type)
		}

        return .success
	}

	func signUp(email: String,
				firstName: String,
				lastName: String,
				password: String,
				preferredName: String,
				birthDate: String,
				userType: String,
				enableEmailNewsOffer: Bool,
				isVerificationRequired: Bool) async -> SignUpCredentialsDetails? {
		if let credentialDetails = await NetworkService.create().signUp(email: email,
													 firstName: firstName,
													 lastName: lastName,
													 password: password,
													 preferredName: preferredName,
													 birthDate: birthDate,
													 userType: userType,
													 enableEmailNewsOffer: enableEmailNewsOffer,
														isVerificationRequired: false) {
			return credentialDetails
		}
		return nil
	}

	func signOut() async {
		let _ = try? await currentUser().fetch(Endpoint.GetLogout())
		tokenRepository.deleteToken()
		currentSailorManager.deleteCurrentSailor()
		let user = try? currentUser()
		user?.delete(Endpoint.GetUserProfile())
		self.userProfile = nil
		self.currentAccount = nil
		self.reservation = nil
        self.error = nil
	}


	// TODO: Why do we need preload reservation which is called in the constructor only.
	private func preloadReservation() {

		guard let user = try? currentUser(), let userProfile = try? user.load(Endpoint.GetUserProfile()) else {
            print("AuthenticationService - preloadReservation: failed to load user or user profile")
			return
		}

		self.userProfile = userProfile

        guard let reservationNumber = currentSailorManager.getCurrentSailor()?.reservationNumber, let reservation = try? user.load(
			Endpoint.GetVoyageReservation(
				reservationNumber: reservationNumber
			)
		) else {
			Task {
				try? await reloadReservation(reservationNumber: currentSailorManager.getCurrentSailor()?.reservationNumber)
			}
			return
		}

		guard let bookingInfo = userProfile.bookingInfo else {
			Task {
				try? await reloadReservation(reservationNumber: currentSailorManager.getCurrentSailor()?.reservationNumber)
			}
			return
		}

		select(reservation: .init(reservation: reservation, bookingInfo: bookingInfo))
    }

    /// Reloads the sailor reservation, user profile, and updates related session state.
    /// - Parameter reservationNumber: Optional reservation number to reload.
    /// - Throws: Validation or data errors if reload fails.
    func reloadReservation(reservationNumber: String? = nil, displayLoadingFlow: Bool = true) async throws {
        
        self.error = nil
        
		let user = try currentUser()
        
        if displayLoadingFlow {
            // Triggers screen flow update (used to show loading states or transitions)
            setIsFetchingReservationFlag(true)
        }
        
        // ───────────────────────────────────────────────────────────────
        // INTENT: Detect reservation switch
        //
        // We may want to set `isSwitchingReservation = true` if:
        // 1. The caller provides a `reservationNumber`
        // 2. The currently active reservation is different from the new one
        //
        // This is temporarily commented out but left for context:
        //
        // if let newReservationNumber = reservationNumber {
        //     if let sailor = try await SailorProfileV2Repository().getSailorProfile(),
        //        let activeReservation = sailor.activeReservation()?.reservationNumber,
        //        newReservationNumber != activeReservation {
        //         self.isSwitchingReservation = true
        //     }
        // }
        // ───────────────────────────────────────────────────────────────

        do {
            // Step 1: Fetch user profile (Legacy)
            self.userProfile = try await user.fetch(Endpoint.GetUserProfile())

            // Step 2: Fetch sailor profile using reservation number (if any provided)
            guard let sailor = try await SailorProfileV2Repository().getSailorProfile(reservationNumber: reservationNumber) else {
                finishReloadingReservation()
                return
            }
            
            // Step 3: Save the active sailor in session (currentSailor in currentSailorManager)
            _ = currentSailorManager.setCurrentSailorFromSailorProfile(sailor: sailor)
            
            // Step 4: if reservartion exists
            if let reservationDetails = sailor.activeReservation(), let reservationSummary = try await reservationRepository.fetchSailorReservationSummary(reservationNumber: reservationDetails.reservationNumber) {
                
                // Step 5: Select the reservation in current session context
                // Temporarily mapping to legacy reservation in order not to introduce even more refactoring.
                // TODO: refactor to map SailorReservationSummary and SailorProfileV2.Reservation to VoyageReservation
                select(reservation: .init(
                    reservation: .init(from: reservationSummary),
                    bookingInfo: .init(
                        guestId: reservationDetails.guestId,
                        embarkDate: reservationDetails.embarkDate,
                        reservationNumber: reservationDetails.reservationNumber,
                        reservationGuestId: reservationDetails.reservationGuestId
                    )
                ))
            }

            // Step 6: Refresh local data caches
            reloadCachedData()

            // Step 7: Finish the reload process and clear state
            finishReloadingReservation()
        } catch {
            self.isFetchingReservation = false
            try handleProfileReservationError(error)
        }
	}
    
    // MARK: - Reload reservation error handling
    private func handleProfileReservationError(_ error: Error) throws {
        print("AuthenticationService - reloadReservation() Error: \(error)")

        if let endpointError = error as? Endpoint.Error {
            // Preserve special-case: Do not set the error for legacy "No user"
            // currentUser() harcodes throw Endpoint.Error("No user") ""
            if endpointError.errorDescription != "No user" {
                self.error = .systemError(endpointError)
            }
        } else if let domainError = error as? VVDomainError {
            self.error = domainError != .unauthorized ? .domainError(domainError) : nil
        } else {
            self.error = .systemError(error)
        }

        // Trigger application screen flow  calculation
        authenticationEventNotificationService.publish(.shouldRecalculateApplicationScreenFlow)
        // Rethrow error so callers can react if needed
        throw error
    }


	private func setIsFetchingReservationFlag(_ isFetching: Bool) {
		self.isFetchingReservation = isFetching
        authenticationEventNotificationService.publish(.shouldRecalculateApplicationScreenFlow)
	}

	private func finishReloadingReservation() {
		// Fallback reset state variables if anything fails.
		self.isFetchingReservation = false

		// self.isSwitchingReservation = false
        authenticationEventNotificationService.publish(.shouldRecalculateApplicationScreenFlow)
    }

	func reloadOnlyTheCurrentSailor() async throws {
		/* This is temporary until we decouple the authentication service from navigation */
		if !isLoggedIn() { return }
        
		// guard let sailor = try await SailorProfileV2Repository().getSailorProfile() else { return }
        // Above line is commented out because getSailorProfile() was returning a user with reservationNumber that is not the same as what we have set when we have change the reservation (in the key value repo).
        

        // In order to compare the current sailor with the server, first get the currently stored current sailor
        let storedCurrentSailor = currentSailorManager.getCurrentSailor()
        // Locally stored reservation number
        let storedReservationNumber = storedCurrentSailor?.reservationNumber
        
        do {
            guard let sailor = try await SailorProfileV2Repository().getSailorProfile(reservationNumber: storedReservationNumber) else {
                return
            }
            
            guard let updatedCurrentSailor = CurrentSailorManager().setCurrentSailorFromSailorProfile(sailor: sailor) else {
                return
            }

            // Check if there is any change between the local and server current sailor model.
            let hasChanged = storedCurrentSailor != updatedCurrentSailor
            if hasChanged {
                reloadCachedData()
            }
        } catch {
            print("AuthenticationService - reloadOnlyTheCurrentSailor : unable to get sailor")
            try? handleProfileReservationError(error)
            return
        }
	}

    private func reloadCachedData() {
		PersistedNetworkCacheStore().removeAllData()

		Task {
			await SessionCacheRefresher().refresh()
		}

        // Sync if user has a reservation
        if userHasReservation() {
            Task {
                await SyncShipTimeUseCase().execute()
                try? await SyncAllAboardTimesUseCase().execute()
                try? await SyncMyAgendaUseCase().execute()
                try? await SyncLineUpUseCase().execute()
            }
        }
	}

	func currentSailor() throws -> Endpoint.SailorAuthentication {
		guard let reservation, let currentAccount, let userProfile else {
			throw Endpoint.Error("No reservation")
		}

		return .init(host: host(), account: currentAccount, userProfile: userProfile, reservation: reservation)
	}

	func currentUser() throws -> Endpoint.UserAuthentication {
		guard let currentAccount else {
			throw Endpoint.Error("No user")
		}

		return .init(host: host(), account: currentAccount)
	}

	func select(reservation: VoyageReservation) {
		self.reservation = reservation
        authenticationEventNotificationService.publish(.shouldRecalculateApplicationScreenFlow)
    }

	func host() -> Endpoint.Host {
		let connectionLocation = LastKnownSailorConnectionLocationRepository().fetchLastKnownSailorConnectionLocation()
		switch connectionLocation {
		case .ship:
			if let reservation {
				if reservation.isSailing() {
					// User is connected to the ship and the selected reservation is active
					return connectionIsVPN ? .ship(.vpn) : .ship(reservation.shipCode)
				} else {
					// User is connected to the ship and the selected reservation is upcoming such as a future voyage
					let env = getVPNNonProdEnvironment()
					return connectionIsVPN ? .vpn(.nonprod(env)) : .shoreside
				}
			} else {
				// User is connected to the ship but still hasn't selected a reservation such as during sign-in
				return connectionIsVPN ? .ship(.vpn) : .ship(.any)
			}

		case .shore:
			let env = getVPNNonProdEnvironment()
			return connectionIsVPN ? .vpn(.nonprod(env)) : .shoreside
		}
	}

	private func getVPNNonProdEnvironment() -> Endpoint.VPN.VPNNonProdEnvironment {
		switch AppConfig.shared.appEnvironment {
		case .int:
			return .integration
		case .cert:
			return .cert
		case .stage:
			return .stage

		default:
			return .dev
		}
	}

	var connectionIsVPN: Bool {
		switch AppConfig.shared.appEnvironment {
		case .cert, .int, .stage:
			return true
		case .prod:
			return false
		}
	}
	/* End legacy ModelData */

	func setAssistingSailor(sailor: Sailor?) {
		self.reservation?.assistingSailor = sailor
	}
}


// MARK: - Login Methods

extension AuthenticationService {

	private func login(email: String, password: String) async throws {
		let response = try await NetworkService.create().signIn(email: email, password: password)
		let token = response.toDomain()
		try await finishLogin(account: token)
	}

	private func login(socialMediaId: String, type: Endpoint.GetSocialAccount.SocialMediaType) async -> LoginResult {
		do {
			let guest = Endpoint.BasicAuthentication(host: host())
			let response = try await guest.fetch(Endpoint.GetSocialAccount(appleId: socialMediaId, type: type))

			let token = Token(
				refreshToken: response.refreshToken ?? "",
				tokenType: response.tokenType,
				accessToken: response.accessToken,
				expiresIn: response.expiresIn,
				status: response.status.toDomain()
			)

			try await finishLogin(account: token)
            return .success
		} catch {
            return .bookingNotFound
		}
	}

	private func login(cabinNumber: String, lastName: String, birthday: Date, reservationGuestId: String? = nil) async throws -> LoginResult {
		let guest = Endpoint.BasicAuthentication(host: host())
		let response = try await guest.fetch(Endpoint.GetCabinAccount(
			lastName: lastName,
			birthDate: birthday,
			cabinNumber: cabinNumber,
            reservationGuestId: reservationGuestId
		))

        let guestsDetails = response.guestDetails ?? []
        if !guestsDetails.isEmpty {
            let mappedGuests = guestsDetails.map { $0.toModel()}
            return .guestConflict(guestDetails: mappedGuests)
        } else {
            let token = Token(
                refreshToken: response.refreshToken.value,
                tokenType: response.tokenType.value,
                accessToken: response.accessToken.value,
                expiresIn: response.expiresIn.value,
                status: response.status?.toDomain() ?? .active
            )
            
            try await finishLogin(account: token)
            return .success
        }
	}

	private func login(lastName: String, reservationNumber: String, birthDate: Date, sailDate: Date, reservationGuestId: String? = nil, recaptchaToken: String? = nil) async throws -> LoginResult {
		let guest = Endpoint.BasicAuthentication(host: host())
		let response = try await guest.fetch(Endpoint.GetReservationNumber(
			lastName: lastName,
			birthDate: birthDate,
			sailDate: sailDate,
			reservationNumber: reservationNumber,
            reservationGuestId: reservationGuestId,
			recaptchaToken: recaptchaToken
		))

        let guestsDetails = response.guestDetails ?? []
        if !guestsDetails.isEmpty {
            let mappedGuests = guestsDetails.map { $0.toModel()}
            return .guestConflict(guestDetails: mappedGuests)
        } else {
            let token = Token(
                refreshToken: response.refreshToken.value,
                tokenType: response.tokenType.value,
                accessToken: response.accessToken.value,
                expiresIn: response.expiresIn.value,
                status: response.status?.toDomain() ?? .active
            )
            try await finishLogin(account: token)
            return .success
        }
	}

	// MARK: - Shared Post-Login Logic

	func finishLogin(account: Token) async throws {
        tokenRepository.storeToken(account)
        await DetectShoresideShipsideUseCase().execute()
        await MonitorShipWiFiConnectivityUseCase().execute()

        currentAccount = account
        try? await reloadReservation()

        _ = await RegisterDeviceTokenUseCase().execute()
	}
}
