//
//  CheckBookingDetailsViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.12.24.
//

import Observation
import Foundation

protocol CheckBookingDetailsViewModelProtocol {
    var claimBookingCheckDetails: ClaimBookingCheckDetails { get }
    func execute() -> Void
    func next(_ completionHandler: @escaping (ClaimBookingUseCaseResult) -> Void)
    
    func navigateBack()
    func openBookingNotFound()
    func openRequiresAuthenticationView()
    func OpenEmailConflictView(email: String, reservationNumber: String, reservationGuestID: String)
    func openGuestConflict(guestDetails: [ClaimBookingGuestDetails])
}

@Observable class CheckBookingDetailsViewModel: BaseViewModel, CheckBookingDetailsViewModelProtocol {

    private var appCoordinator: CoordinatorProtocol
	private let profileRepository: SailorProfileRepositoryProtocol

    private var claimBookingUseCase: ClaimBookingUseCase
    private var claimBookingCheckDetailsUseCase: ClaimBookingCheckDetailsUseCaseProtocol
    
    private var selectedGuest: ClaimBookingGuestDetails

    var claimBookingCheckDetails: ClaimBookingCheckDetails
    let bookingReferenceNumber: String

    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
		 profileRepository: SailorProfileRepositoryProtocol = SailorProfileRepository(),
         claimBookingUseCase: ClaimBookingUseCase = ClaimBookingUseCase(),
         claimBookingCheckDetailsUseCase: ClaimBookingCheckDetailsUseCaseProtocol,
         bookingReferenceNumber: String,
         selectedGuest: ClaimBookingGuestDetails,
         screenState: ScreenState = .content,
         claimBookingCheckDetails: ClaimBookingCheckDetails) {
        
        self.appCoordinator = appCoordinator
		self.profileRepository = profileRepository
        self.claimBookingUseCase = claimBookingUseCase
        self.claimBookingCheckDetailsUseCase = claimBookingCheckDetailsUseCase
        self.bookingReferenceNumber = bookingReferenceNumber
        self.selectedGuest = selectedGuest
        self.claimBookingCheckDetails = claimBookingCheckDetails
    }

 
    func execute() {
        Task {
            let result = await claimBookingCheckDetailsUseCase.execute()
			await executeOnMain({
				claimBookingCheckDetails = result
			})
        }
    }
    
    func next(_ completionHandler: @escaping (ClaimBookingUseCaseResult) -> Void) {

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
    
    func openBookingNotFound() {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenBookingNotFoundCommand())
    }

    func openRequiresAuthenticationView() {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenRequiresAuthenticationCommand())
    }
    
    func OpenEmailConflictView(email: String, reservationNumber: String, reservationGuestID: String) {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenEmailConflictViewCommand(email: email, reservationNumber: reservationNumber, reservationGuestID: reservationGuestID))
    }
    
    func openGuestConflict(guestDetails: [ClaimBookingGuestDetails]) {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenGuestConflictViewCommand(currentGuest: selectedGuest, bookingReferenceNumber: bookingReferenceNumber, guestDetails: guestDetails))
    }
    
    
}
