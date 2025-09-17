//
//  ClaimBookingSelectSailorViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/17/24.
//

import Foundation

enum ClaimBookingSelectSailorViewModelState: Equatable {
	case bookingNotFound
	case guestConflict(guestDetails: [ClaimBookingGuestDetails])
	case successRequiresAuthentication
}

@Observable class ClaimBookingSelectSailorViewModel: ClaimBookingSelectSailorViewModelProtocol {
    
    private var appCoordinator: CoordinatorProtocol

    let bookingReferenceNumber: String
    let guestDetails: [ClaimBookingGuestDetails]
    let claimBookingUseCase: ClaimBookingUseCase
    let getUserProfileUseCase: GetUserProfileUseCaseProtocol
	private let profileRepository: SailorProfileRepositoryProtocol

	var state: ClaimBookingSelectSailorViewModelState? = nil
    private var currentGuest: ClaimBookingGuestDetails?
    var selectedGuest: ClaimBookingGuestDetails?


    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
		 profileRepository: SailorProfileRepositoryProtocol = SailorProfileRepository(),
         currentGuest: ClaimBookingGuestDetails? = nil,
         bookingReferenceNumber: String,
         guestDetails: [ClaimBookingGuestDetails],
         claimBookingUseCase: ClaimBookingUseCase = ClaimBookingUseCase(),
         getUserProfileUseCase: GetUserProfileUseCaseProtocol = GetUserProfileUseCase()) {
        self.appCoordinator = appCoordinator
		self.profileRepository = profileRepository
        self.currentGuest = currentGuest
        self.bookingReferenceNumber = bookingReferenceNumber
        self.guestDetails = guestDetails
        self.claimBookingUseCase = claimBookingUseCase
        self.getUserProfileUseCase = getUserProfileUseCase
    }
    
    func autoSelectCurrentUser() async {
        if let currentGuest, let birthDate = currentGuest.birthDate?.toMonthDayYear() {
            self.selectedGuest = guestDetails.first(where: {
                return $0.lastName == currentGuest.lastName && $0.reservationNumber == bookingReferenceNumber && $0.birthDate?.toMonthDayYear() == birthDate
            })
            return
        }
        
        // logged in user data
        if let userProfile = await getUserProfileUseCase.execute() {
            self.selectedGuest = guestDetails.first(where: {
                return $0.lastName == userProfile.lastName && $0.reservationNumber == bookingReferenceNumber && $0.birthDate?.toMonthDayYear() == userProfile.birthDate
            })
        }
    }
    
    
    var isNextButtonDisabled: Bool {
        return selectedGuest == nil
    }
    
	func next(_ completionHandler: @escaping (ClaimBookingUseCaseResult) -> Void) {
        guard let selectedGuest else {
            return
        }
        
        Task {
            let result = await claimBookingUseCase.execute(email: profileRepository.profile()?.email ?? "",
														   lastName: selectedGuest.lastName,
                                                           birthDate: selectedGuest.birthDate ?? Date(),
														   reservationNumber: selectedGuest.reservationNumber,
														   reservationGuestID: selectedGuest.reservationGuestID)
			DispatchQueue.main.async {
				completionHandler(result)
			}
        }
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
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenBookingNotFoundCommand())
    }
    
    func openGuestConflict(guestDetails: [ClaimBookingGuestDetails]) {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenGuestConflictViewCommand(currentGuest: selectedGuest, bookingReferenceNumber: bookingReferenceNumber, guestDetails: guestDetails))
    }
    
    func openCheckBookingDetails(selectedGuest: ClaimBookingGuestDetails) {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenCheckBookingDetailsCommand(bookingReferenceNumber: bookingReferenceNumber, selectedGuest: selectedGuest))
    }
    
    func openMissingBookingDetails(selectedGuest: ClaimBookingGuestDetails) {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenMissingBookingDetailsCommand(bookingReferenceNumber: bookingReferenceNumber, selectedGuest: selectedGuest))
    }
    
}
