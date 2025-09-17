//
//  ClaimBookingReservationDetailsViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/10/24.
//

import Foundation

@Observable class ClaimBookingReservationDetailsViewModel: RecaptchaContainingViewModelProtocol {

    private var appCoordinator: CoordinatorProtocol
    
	var isBookingReferenceInfoModalVisible: Bool = false

	var isSearchButtonDisabled: Bool {
		return reservationNumber.isEmpty || !recaptchaPassed()
	}

    var reservationNumber: String = ""
    
    private var profileRepository: SailorProfileRepositoryProtocol
    private var claimBookingUseCase: ClaimBookingUseCase
    private var currentGuest: ClaimBookingGuestDetails? = nil
    var showCloseFlowButton: Bool
    
    var reCaptchaRefreshID: UUID = UUID()
    var reCaptchaToken: String?
    var reCaptchaIsChecked: Bool = false
    var reCaptchaError: String?

    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         showCloseFlowButton: Bool = false,
         profileRepository: SailorProfileRepositoryProtocol = SailorProfileRepository(),
         claimBookingUseCase: ClaimBookingUseCase = ClaimBookingUseCase()) {
        
        self.appCoordinator = appCoordinator
        self.showCloseFlowButton = showCloseFlowButton
        self.profileRepository = profileRepository
        self.claimBookingUseCase = claimBookingUseCase
    }
    
    var sailorLastName: String? {
        return profileRepository.profile()?.lastName
    }
    
    var sailorDateOfBirth: String? {
        return profileRepository.profile()?.dateOfBirth?.toMonthDDYYY()
    }

	func claimBooking(_ completionHandler: @escaping (ClaimBookingUseCaseResult) -> Void) {
        guard let profile = profileRepository.profile(),
              let birthDate = profile.dateOfBirth else {
            return
        }
        
        let email = profile.email
        let lastName = profile.lastName
        
        Task {
            let result = await claimBookingUseCase.execute(email: email,
                                                           lastName: lastName,
                                                           birthDate: birthDate,
                                                           reservationNumber: reservationNumber,
                                                           reCaptchaToken: reCaptchaToken.value)
            currentGuest = .init(email: email, lastName: lastName, birthDate: birthDate, reservationNumber: reservationNumber, reservationGuestID: "")
            DispatchQueue.main.async {
				completionHandler(result)
            }
        }
    }

	func toggleBookingReferenceInfoModal() {
		isBookingReferenceInfoModalVisible = !isBookingReferenceInfoModalVisible
	}
    
    
    private func recaptchaPassed() -> Bool {
        if let reCaptchaToken, !reCaptchaToken.isEmpty {
            return true
        }
        return false
    }
    
    private func resetReCaptcha() {
        reCaptchaRefreshID = UUID()
        reCaptchaToken = nil
        reCaptchaIsChecked = false
    }
    
    
    // MARK: Navigation
    func navigateBack() {
        appCoordinator.executeCommand(ClaimABookingCoordinator.GoBackCommand())
    }
    
    func cancel() {
        appCoordinator.executeCommand(ClaimABookingCoordinator.GoBackToRootViewCommand())
    }
    
    func openRequiresAuthenticationView() {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenRequiresAuthenticationCommand())
    }

    func openBookingNotFound() {
        resetReCaptcha()
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenBookingNotFoundCommand())
    }
    
    func OpenEmailConflictView(email: String, reservationNumber: String, reservationGuestID: String) {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenEmailConflictViewCommand(email: email, reservationNumber: reservationNumber, reservationGuestID: reservationGuestID))
    }
    
    func openGuestConflict(guestDetails: [ClaimBookingGuestDetails]) {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenGuestConflictViewCommand(currentGuest: currentGuest, bookingReferenceNumber: reservationNumber, guestDetails: guestDetails))
    }
}
