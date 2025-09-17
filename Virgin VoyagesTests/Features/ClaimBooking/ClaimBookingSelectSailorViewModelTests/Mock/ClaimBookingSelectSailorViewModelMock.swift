//
//  ClaimBookingSelectSailorViewModelMock.swift
//  Virgin VoyagesTests
//
//  Created by TX on 10.2.25.
//

import Foundation
@testable import Virgin_Voyages

class MockGetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    var mockUserProfile: UserProfile?
    
    func execute() async -> UserProfile? {
        return mockUserProfile
    }
}

class MockCoordinator: CoordinatorProtocol {
    
    var currentFlow: ApplicationFlow = .initialLoading
    
    var offlineModeLandingScreenCoordinator: OfflineModeHomeLandingScreenCoordinator = .init()
	var homeTabBarCoordinator: HomeTabBarCoordinator = HomeTabBarCoordinator(selectedTab: .dashboard)
    var landingScreenCoordinator: LandingScreensCoordinator = .init()
    var discoverCoordinator: DiscoverCoordinator = .init()
    var authenticationService: AuthenticationServiceProtocol = MockAuthenticationService()
    var currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()
    
    func executeCommand(_ command: any NavigationCommandProtocol) { }
    func calculateCurrentScreenFlow() { }

}

extension UserProfile {
    static func mockUser(withLastname lastName: String, reservationNumber: String, birthDateString: String) -> UserProfile {
        UserProfile(
            firstName: "",
            lastName: lastName,
            photoUrl: "",
            bookingInfo: UserProfile.BookingInfo(embarkDate: "", reservationNumber: reservationNumber, guestId: "", reservationGuestId: "", status: "", isVIP: false, guestTypeCode: ""),
            birthDate: birthDateString,
            phoneCountryCode: "",
            userNotifications: [],
            email: "",
            isPasswordExist: true,
            personId: "",
            personTypeCode: "",
            hasLinkedReservations: true,
            emailVerificationStatus: "",
            citizenshipCountryCode: "",
            preferredName: ""
        )
    }
}
