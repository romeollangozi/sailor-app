//
//  EateryReceiptScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 8.4.25.
//

import Foundation

@Observable class EateryReceiptScreenViewModel : BaseViewModel, EateryReceiptScreenViewModelProtocol {
	private let appointmentId: String
	private let getEateryAppointmentDetailsUseCase: GetEateryAppointmentDetailsUseCaseProtocol
	private let eateriesSlotsUseCase: GetEateriesSlotsUseCaseProtocol
    private let getMySailorsUseCase: GetMySailorsUseCaseProtocol
	
	var screenState: ScreenState = .loading
	var showEditSlotBookSheet: Bool = false
	var appointmentDetails: EateryAppointmentDetails = EateryAppointmentDetails.empty()
	var editBookingViewModel: EditBookingSheetViewModel? = nil
	var eateryWithSlots: EateriesSlots.Restaurant? = nil
    var availableSailors: [SailorModel] = []
	
	init(appointmentId: String,
		 getEateryAppointmentDetailsUseCase: GetEateryAppointmentDetailsUseCaseProtocol = GetEateryAppointmentDetailsUseCase(),
		 eateriesSlotsUseCase: GetEateriesSlotsUseCaseProtocol = GetEateriesSlotsUseCase(),
         getMySailorsUseCase: GetMySailorsUseCaseProtocol = GetMySailorsUseCase()) {
		self.appointmentId = appointmentId
		self.getEateryAppointmentDetailsUseCase = getEateryAppointmentDetailsUseCase
		self.eateriesSlotsUseCase = eateriesSlotsUseCase
        self.getMySailorsUseCase = getMySailorsUseCase
	}
	
	func onAppear() {
		Task {
			await loadScreenData()
		}
	}
	
	func onRefresh() {
		Task {
			await loadScreenData()
		}
	}
	
	func onEditBookingClick() {
		editBookingViewModel = .init(initialSlotId: appointmentDetails.slotId,
									 initialSlotDate: appointmentDetails.startDateTime,
									 externalId: appointmentDetails.externalId,
									 venueId: appointmentDetails.venueId,
									 initialSailorsIds: appointmentDetails.sailors.map { $0.reservationGuestId },
									 appointmentLinkId: appointmentDetails.linkId,
									 mealPeriod: appointmentDetails.mealPeriod,
									 eateryName: appointmentDetails.name,
									 isWithinCancellationWindow: appointmentDetails.isWithinCancellationWindow)
		
		showEditSlotBookSheet = true
	}
	
	func onBookingCompleted() {
		hideEditBookingSheet()
		
		Task {
			await loadAppointmentDetails()
		}
	}
	
	func onBookingCanceled() {
		hideEditBookingSheet()
		
		executeNavigationCommand(HomeTabBarCoordinator.RemoveReceipScreenCommand())
	}
	
	func onEditBookingSheetDismiss() {
		hideEditBookingSheet()
	}
	
	private func hideEditBookingSheet() {
		editBookingViewModel = nil
		showEditSlotBookSheet = false
	}
	
	func onViewAllTapped() {
		executeNavigationCommand(HomeTabBarCoordinator.OpenDiscoverEateriesListCommand())
	}
    
    private func loadScreenData() async {
        await loadAppointmentDetails()
        
        await loadAvailableSailors()
        
        await executeOnMain({
            self.screenState = .content
        })
    }
	
	private func loadAppointmentDetails() async {
		if let result = await executeUseCase({
			try await self.getEateryAppointmentDetailsUseCase.execute(appointmentId: self.appointmentId)
		}) {
			await executeOnMain({
				self.appointmentDetails = result
			})
		} else {
			await executeOnMain({
				self.screenState = .error
			})
		}
	}
    
    private func loadAvailableSailors(useCache: Bool = true) async {
        if let result = await executeUseCase({
            try await self.getMySailorsUseCase.execute(useCache: useCache)
        }) {
            await executeOnMain({
                self.availableSailors = result.filterByReservationGuestIds(self.appointmentDetails.sailors.getOnlyReservationGuestIds())
            })
        }
    }
}
