//
//  ClaimBookingEmailConflictViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/13/24.
//

import SwiftUI

@Observable class ClaimBookingEmailConflictViewModel {
    private var appCoordinator: CoordinatorProtocol
	private let email: String
	private let reservationNumber: String
	private let reservationGuestID: String
	private let claimBookingUseCase: ClaimBookingUseCase
	private let profileRepository: SailorProfileRepositoryProtocol
    private var currentGuest: ClaimBookingGuestDetails? = nil

	var selectedEmail: String?

	var isNextButtonDisabled: Bool {
		return selectedEmail == nil
	}

	var emails: [String] {
		let profileEmail = profileRepository.profile()?.email ?? ""
		return [profileEmail, email]
	}

	init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         email: String,
		 reservationNumber: String,
		 reservationGuestID: String,
		 claimBookingUseCase: ClaimBookingUseCase = ClaimBookingUseCase(),
		 profileRepository: SailorProfileRepositoryProtocol = SailorProfileRepository()) {
        
        self.appCoordinator = appCoordinator
		self.email = email
		self.reservationNumber = reservationNumber
		self.reservationGuestID = reservationGuestID
		self.claimBookingUseCase = claimBookingUseCase
		self.profileRepository = profileRepository
	}

	@MainActor
	func next(_ completionHandler: @escaping (ClaimBookingGuestDetails) -> Void) {
		guard let selectedEmail,
			  let lastName = profileRepository.profile()?.lastName,
			  let dateOfBirth = profileRepository.profile()?.dateOfBirth else { return }

		let selectedGuest = ClaimBookingGuestDetails(
			email: selectedEmail,
			lastName: lastName,
			birthDate: dateOfBirth,
			reservationNumber: reservationNumber,
			reservationGuestID: reservationGuestID
		)

		self.currentGuest = selectedGuest
		completionHandler(selectedGuest)
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

    func openBookingNotFound() {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenBookingNotFoundCommand())
    }
    
    func OpenEmailConflictView(email: String, reservationNumber: String, reservationGuestID: String) {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenEmailConflictViewCommand(email: email, reservationNumber: reservationNumber, reservationGuestID: reservationGuestID))
    }
    
    func openGuestConflict(guestDetails: [ClaimBookingGuestDetails]) {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenGuestConflictViewCommand(currentGuest: currentGuest, bookingReferenceNumber: reservationNumber, guestDetails: guestDetails))
    }

	func openCheckBookingDetailsView() {
		guard let selectedGuest = currentGuest else { return }
		appCoordinator.executeCommand(ClaimABookingCoordinator.OpenCheckBookingDetailsCommand(bookingReferenceNumber: selectedGuest.reservationNumber, selectedGuest: selectedGuest))
	}

}
