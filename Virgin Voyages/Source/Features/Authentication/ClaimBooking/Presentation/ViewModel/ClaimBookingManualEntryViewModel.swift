//
//  ClaimBookingManualEntryViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/16/24.
//

import Foundation

@Observable class ClaimBookingManualEntryViewModel: RecaptchaContainingViewModelProtocol {

    var appCoordinator: CoordinatorProtocol

	private var profileRepository: SailorProfileRepositoryProtocol
	private var claimBookingUseCase: ClaimBookingUseCase

    var reCaptchaRefreshID = UUID()
    var reCaptchaToken: String?
    var reCaptchaIsChecked: Bool = false
    var reCaptchaError: String?
    
	init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         profileRepository: SailorProfileRepositoryProtocol = SailorProfileRepository(),
		 claimBookingUseCase: ClaimBookingUseCase = ClaimBookingUseCase()) {
		
        self.appCoordinator = appCoordinator
        self.profileRepository = profileRepository
		self.claimBookingUseCase = claimBookingUseCase
	}

	var bookingReferenceNumber: String = ""
	var lastName: String = ""
	var shouldShowBookingNotFoundModal: Bool = false
    var sailorServicesPhoneNumber = SupportPhones.sailorServicesPhoneNumber
    private var currentGuest: ClaimBookingGuestDetails?


	var isSearchButtonDisabled: Bool {
		return lastName.isEmpty || bookingReferenceNumber.isEmpty || dateOfBirth.day == nil || dateOfBirth.month == nil || dateOfBirth.year == nil || dateOfBirthError != nil || !recaptchaPassed()
	}

	var dateOfBirthError: String? {
		if dateOfBirth.isFullySpecifiedDate() {
			return dateOfBirth.isValidDate() ? nil : ""
		}
		return nil
	}

	var dateOfBirth: DateComponents = DateComponents(calendar: Calendar.current)

	func showBookingNotFoundModal() {
        resetReCaptcha()
        shouldShowBookingNotFoundModal = true
	}

	func closeBookingNotFoundModal() {
		shouldShowBookingNotFoundModal = false
	}

	func search(_ completionHandler: @escaping (ClaimBookingUseCaseResult) -> Void) {
		let calendar = Calendar.current
		guard let email = profileRepository.profile()?.email,
			  let birthDate = calendar.date(from: self.dateOfBirth) else {
			return
		}

		Task {
			let result = await claimBookingUseCase.execute(email: email,
														   lastName: lastName,
														   birthDate: birthDate,
														   reservationNumber: bookingReferenceNumber,
                                                           reCaptchaToken: reCaptchaToken.value)
            
            currentGuest = .init(email: email, lastName: lastName, birthDate: birthDate, reservationNumber: bookingReferenceNumber, reservationGuestID: "")

			DispatchQueue.main.async {
				completionHandler(result)
			}
		}
	}
    
    private func resetReCaptcha() {
        reCaptchaRefreshID = UUID()
        reCaptchaToken = nil
        reCaptchaIsChecked = false
    }
    
    private func recaptchaPassed() -> Bool {
        if let reCaptchaToken, !reCaptchaToken.isEmpty {
            return true
        }
        return false
    }
    
    // MARK: Navigation
    func navigateBack() {
        appCoordinator.executeCommand(ClaimABookingCoordinator.GoBackCommand())
    }
    
    func navigateBackToRoot() {
        appCoordinator.executeCommand(ClaimABookingCoordinator.GoBackToRootViewCommand())
    }

    func openRequiresAuthenticationView() {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenRequiresAuthenticationCommand())
    }
    
    func OpenEmailConflictView(email: String, reservationNumber: String, reservationGuestID: String) {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenEmailConflictViewCommand(email: email, reservationNumber: reservationNumber, reservationGuestID: reservationGuestID))
    }
    
    func openGuestConflict(guestDetails: [ClaimBookingGuestDetails]) {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenGuestConflictViewCommand(currentGuest: currentGuest, bookingReferenceNumber: bookingReferenceNumber, guestDetails: guestDetails))
    }
}
