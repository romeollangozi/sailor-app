//
//  EaterySlotBookViewModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 27.11.24.
//

import Foundation

@Observable class EaterySlotBookViewModel : BaseViewModel, EaterySlotBookViewModelProtocol {
	private let bookSlotUseCase: BookSlotUseCaseProtocol
	private let getEateryConflicsUseCase: GetEateryConflictsUseCaseProtocol
	private let swapBookingSlotUseCase: SwapBookingSlotUseCaseProtocol
	private let mySailorsUseCase: GetMySailorsUseCaseProtocol
	
	var screenState: ScreenState = .loading
	var title: String
	var activityCode: String
	var slot: Slot
	var mealPeriod: MealPeriod
	var disclaimer: String?
	var isSwapping: Bool = false
	var isBookingCompleted : Bool = false
	var isSwapCompleted: Bool = false
	var selectedSailors: [SailorModel] = []
	var warningForSailors: [SailorModel] = []
	var bookSlotErrorMessage: String? = nil
	var conflictData: EateryConflictsModel = EateryConflictsModel.none
	var acknowledgeDisclaimer: Bool = false
	var showDisclaimerErroMessage: Bool = false
	var availableSailors: [SailorModel] = []
	
	init(title: String,
		 activityCode: String,
		 slot: Slot,
		 mealPeriod: MealPeriod,
		 selectedSailors: [SailorModel] = [],
		 disclaimer: String? = nil,
		 bookSlotUseCase: BookSlotUseCaseProtocol = BookSlotUseCase(),
		 getEateryConflicsUseCase: GetEateryConflictsUseCaseProtocol = GetEateryConflictsUseCase(),
		 swapBookingSlotUseCase: SwapBookingSlotUseCaseProtocol = SwapBookingSlotUseCase(),
		 mySailorsUseCase: GetMySailorsUseCaseProtocol = GetMySailorsUseCase()
	) {
		self.title = title
		self.activityCode = activityCode
		self.slot = slot
		self.disclaimer = disclaimer
		self.selectedSailors = selectedSailors
		self.mealPeriod = mealPeriod
		self.disclaimer = disclaimer
		
		self.bookSlotUseCase = bookSlotUseCase
		self.getEateryConflicsUseCase = getEateryConflicsUseCase
		self.swapBookingSlotUseCase = swapBookingSlotUseCase
		self.mySailorsUseCase = mySailorsUseCase
	}
	
	func onAppear() async {
		await loadAvailableSailors()
		
		await loadConflicts()
		
		await executeOnMain({
			self.screenState = .content
		})
	}
	
	func onRefresh() async {
		await loadAvailableSailors()
		
		await loadConflicts()
		
		await executeOnMain({
			self.screenState = .content
		})
	}
	
	func onBookClick() async {
        if (disclaimer != nil && !self.acknowledgeDisclaimer) {
            await executeOnMain({
                self.showDisclaimerErroMessage = true
            })
            return
        }
		if isSwapping {
			await swapBooking()
		} else {
			await createBooking()
		}
	}
	
	private func createBooking() async {
		await executeOnMain({
			self.screenState = .loading
			self.isBookingCompleted = false
			self.bookSlotErrorMessage = nil
		})
		
		do {
			let input = BookSlotInputModel(personDetails: selectedSailors.map({
				sailor in .init(personId: sailor.reservationGuestId,
								reservationNumber: sailor.reservationNumber,
								guestId: sailor.guestId)
			}),
										   activityCode: self.activityCode,
										   activitySlotCode:self.slot.id,
										   startDate: self.slot.startDateTime)
			
			let result = try await UseCaseExecutor.execute {
				try await self.bookSlotUseCase.execute(input: input)
			}
			
			if(result.appointment != nil) {
				await executeOnMain({
					self.isBookingCompleted = true
				})
			} else if(result.error != nil) {
				await executeOnMain({
					self.bookSlotErrorMessage = result.error?.title
				})
			}
		} catch {
			await executeOnMain({
				self.bookSlotErrorMessage = "Sorry sailor, it looks like we had a glitch in the matrix. please try again"
			})
		}
		
		await executeOnMain({
			self.screenState = .content
		})
	}
	
	private func swapBooking() async {
		await executeOnMain({
			self.screenState = .loading
			self.isSwapCompleted = false
			self.bookSlotErrorMessage = nil
		})
		
		do {
			let input = SwapBookingSlotInputModel(personDetails: selectedSailors.map({
				sailor in .init(personId: sailor.reservationGuestId,
								reservationNumber: sailor.reservationNumber,
								guestId: sailor.guestId)
			}),
												  activityCode: self.activityCode,
												  activitySlotCode:self.slot.id,
												  startDate: self.slot.startDateTime,
												  appointmentLinkId: conflictData.conflict?.swapConflictDetails?.cancellableBookingLinkId ?? "")
			
			let result = try await UseCaseExecutor.execute {
				try await self.swapBookingSlotUseCase.execute(input: input)
			}
			
			if(result.appointment != nil) {
				await executeOnMain({
					self.isSwapCompleted = true
				})
			} else if(result.error != nil) {
				await executeOnMain({
					self.bookSlotErrorMessage = result.error?.title
				})
			}
		} catch {
			await executeOnMain({
				self.bookSlotErrorMessage = "Sorry sailor, it looks like we had a glitch in the matrix. please try again"
			})
		}
		
		await executeOnMain({
			self.screenState = .content
		})
	}
	
	func onConfirmSwapClick() {
		self.isSwapping = true
	}
	
	private func loadConflicts() async {
		let conflictsInput = EateryConflictsInputModel(personDetails: selectedSailors.map({
			x in EateryConflictsInputModel.PersonDetail(personId: x.reservationGuestId)
		}),
													   activityCode: activityCode,
													   activitySlotCode: slot.id,
													   startDateTime: slot.startDateTime,
													   mealPeriod: mealPeriod)
		
		if let result = await executeUseCase({
			try await self.getEateryConflicsUseCase.execute(input: conflictsInput)
		}) {
			if let conflict = result.conflict {
				await executeOnMain {
					self.conflictData = result
					self.warningForSailors = availableSailors.filterByReservationGuestIds(conflict.personDetails.map{$0.personId})
				}
			}
		}
	}
	
	private func loadAvailableSailors() async {
		if let result = await executeUseCase({
			try await self.mySailorsUseCase.execute(useCache: true)
		}) {
			await executeOnMain({
				self.availableSailors = result.filterByReservationGuestIds(self.selectedSailors.getOnlyReservationGuestIds())
			})
		}
	}
}
