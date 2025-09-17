//
//  VoyageSelectionScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 2.6.25.
//

import SwiftUI

@Observable class VoyageSelectionScreenViewModel: BaseViewModel, VoyageSelectionScreenViewModelProtocol {
    private let getVoyageReservationsUseCase: GetVoyageReservationsUseCaseProtocol
    private let logoutUserUseCase: LogoutUserUseCaseProtocol
    private let authenticationService: AuthenticationServiceProtocol
    private let onVoyageChanged: (String) -> Void
    private let onCurrentVoyageSelected: () -> Void
    
    var screenState: ScreenState = .loading
    var voyageReservations: VoyageReservations = VoyageReservations.empty()
 
    var archivedVoyageReservations: [VoyageReservations.GuestBooking] {
        voyageReservations.guestBookings.filter { $0.isArchivedBooking }
    }

    init(
    getVoyageReservationsUseCase: GetVoyageReservationsUseCaseProtocol = GetVoyageReservationsUseCase(),
    logoutUserUseCase: LogoutUserUseCaseProtocol = LogoutUserUseCase(),
    authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared,
    onVoyageChanged: @escaping (String) -> Void,
    onCurrentVoyageSelected: @escaping () -> Void
    ) {
        self.getVoyageReservationsUseCase = getVoyageReservationsUseCase
        self.logoutUserUseCase = logoutUserUseCase
        self.authenticationService = authenticationService
        self.onVoyageChanged = onVoyageChanged
        self.onCurrentVoyageSelected = onCurrentVoyageSelected
    }
    
    func onAppear() {
        Task {
            await loadVoyageReservations()
        }
    }
        
    func didTapLogout() {
        Task {
            await logoutUserUseCase.execute()
        }
    }
    
    func didTapClamABooking() {
        navigationCoordinator.executeCommand(MeCoordinator.OpenClaimABookingCommand())
    }
    
    
    func didTapAnotherVoyage() {
        let urlString: String = "https://www.virginvoyages.com"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func didTapScheduleVoyage() {
        let urlString: String = "https://www.virginvoyages.com/book"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func reloadReservation(reservationNumber: String) {
        Task {
            do {
                //Reload the reservation if it is not the current one
                if (authenticationService.reservation?.reservationNumber != reservationNumber) {
                    try await authenticationService.reloadReservation(reservationNumber: reservationNumber, displayLoadingFlow: true)
                    onVoyageChanged(reservationNumber)
                } else {
                    self.onCurrentVoyageSelected()
                }
            } catch {
                print("Error selecting booking: \(error)")
            }
        }
    }
    
    func isActiveReservation(voyage: VoyageReservations.GuestBooking) -> Bool {
        authenticationService.reservation?.reservationNumber == voyage.reservationNumber
    }
    
    private func loadVoyageReservations() async {
        if let result = await executeUseCase({
            try await self.getVoyageReservationsUseCase.execute(useCache: false)
        }) {
            await executeOnMain({
                self.voyageReservations = result
                self.screenState = .content
            })
        } else {
            await executeOnMain({
                self.screenState = .error
            })
        }
    }
}
