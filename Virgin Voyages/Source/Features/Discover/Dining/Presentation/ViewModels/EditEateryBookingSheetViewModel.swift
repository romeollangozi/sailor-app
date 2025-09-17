//
//  EditBookingSheetViewModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 4.12.24.
//
import Foundation

@Observable class EditBookingSheetViewModel: BaseViewModel, EditEateryBookingSheetViewModelProtocol {
	private let eateriesSlotsUseCase: GetEateriesSlotsUseCaseProtocol
	private let updateBookingSlotUseCase: UpdateBookingSlotUseCaseProtocol
	private let cancelBookingSlotUseCase: CancelBookingSlotUseCaseProtocol
	private let mySailorsUseCase: GetMySailorsUseCaseProtocol
	private let itineraryDatesUseCase : GetItineraryDatesUseCaseProtocol
	private var slots:[Slot] = []
	private let friendsEventsNotificationService: FriendsEventsNotificationService
	private let listenerKey = "EditBookingSheetViewModel"
	
	var screenState: ScreenState = .loading
	var availableSailors: [SailorModel] = []
	
	var previousBookedSailorIds: [String]
	var previousSlotId: String
	var previousSlotStartDate: Date
	
	var externalId: String
	var appointmentLinkId: String
	var eateryName: String
	var isWithinCancellationWindow: Bool
	
	var availableDates: [Date] = []
	var isEateriesSlotsLoading = false
	var availableTimeSlots: [TimeSlotOptionV2] = []
	
	var selectedTimeSlot: TimeSlotOptionV2 = .empty
		
	var warningForSailors: [SailorModel] = []
	
	var isBookingCompleted: Bool = false
	var bookSlotErrorMessage: String? = nil
	var cancelErrorMessage: String? = nil
	
	var showBookingCancellationConfirmation: Bool = false
	var isCancelBookSlotLoading: Bool = false
	var isCancelCompleted: Bool = false
	var showAddFriend: Bool = false
	
	var filter: EateriesSlotsInputModel
	
	init(
		initialSlotId: String,
		initialSlotDate: Date,
		externalId: String,
		venueId: String,
		initialSailorsIds: [String],
		appointmentLinkId: String,
		mealPeriod: MealPeriod,
		eateryName: String,
		isWithinCancellationWindow: Bool,
		eateriesSlotsUseCase: GetEateriesSlotsUseCaseProtocol = GetEateriesSlotsUseCase(),
		updateBookingSlotUseCase: UpdateBookingSlotUseCaseProtocol = UpdateBookingSlotUseCase(),
		cancelBookingSlotUseCase: CancelBookingSlotUseCaseProtocol = CancelBookingSlotUseCase(),
		mySailorsUseCase: GetMySailorsUseCaseProtocol = GetMySailorsUseCase(),
		itineraryDatesUseCase: GetItineraryDatesUseCaseProtocol = GetItineraryDatesUseCase(),
		friendsEventsNotificationService: FriendsEventsNotificationService = .shared
	) {
		self.previousBookedSailorIds = initialSailorsIds
		self.previousSlotId = initialSlotId
		self.previousSlotStartDate = initialSlotDate
		
		self.externalId = externalId
		
		self.appointmentLinkId = appointmentLinkId
		self.eateryName = eateryName
		self.isWithinCancellationWindow = isWithinCancellationWindow
				
		filter = EateriesSlotsInputModel(searchSlotDate: initialSlotDate,
										 mealPeriod: mealPeriod,
										 venues: [.init(externalId: externalId, venueId: venueId)],
										 guests: [])
		
		self.eateriesSlotsUseCase = eateriesSlotsUseCase
		self.updateBookingSlotUseCase = updateBookingSlotUseCase
		self.cancelBookingSlotUseCase = cancelBookingSlotUseCase
		self.mySailorsUseCase = mySailorsUseCase
		self.itineraryDatesUseCase = itineraryDatesUseCase
		self.friendsEventsNotificationService = friendsEventsNotificationService
		
		super.init()
		self.startObservingEvents()
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
	
	private func loadScreenData() async {
		loadItineraryDates()
		
		await loadAvailableSailors()
		
		self.screenState = .content
		
		await loadEateriesSlots()
	}
	
	func onFilterChanged() {
		Task {
			await loadEateriesSlots()
		}
	}
	
	func onUpdateBookSlotClick() {
		Task {
			await updateBooking()
		}
	}
	
	func onCancelClick() {
		showBookingCancellationConfirmation = true
	}
	
	func onCancellationFlowFinished() {
		showBookingCancellationConfirmation = false
		isCancelCompleted = true
	}
	
	func onCancellationFlowDismiss() {
		showBookingCancellationConfirmation = false
	}
	
	func cancelAppointment(guests: Int) async -> Bool {
		await executeOnMain {
			self.isCancelBookSlotLoading = true
			self.cancelErrorMessage = nil
		}
		
		do {
			let input = CancelBookingSlotInputModel(personDetails: filter.guests.map({
				sailor in .init(personId: sailor.reservationGuestId,
								reservationNumber: sailor.reservationNumber,
								guestId: sailor.guestId)
			}),
													activityCode: self.externalId,
													activitySlotCode: self.previousSlotId,
													startDate: self.previousSlotStartDate,
													appointmentLinkId: self.appointmentLinkId,
													guests: guests)
			
			let result = try await UseCaseExecutor.execute {
				try await self.cancelBookingSlotUseCase.execute(input: input)
			}
			
			if(result.appointment != nil) {
				await executeOnMain {
					self.isCancelBookSlotLoading = false
				}
				
				return true
			} else if(result.error != nil) {
				await executeOnMain {
					self.isCancelBookSlotLoading = false
					self.cancelErrorMessage = result.error?.title
				}
				
				return false
			}
			
		} catch {
			await executeOnMain({
				self.cancelErrorMessage = "Sorry sailor, it looks like we had a glitch in the matrix. please try again"
			})
		}
		
		await executeOnMain {
			self.isCancelBookSlotLoading = false
		}
		
		return false
	}
	
	func IsUpdateButtonDisabled() -> Bool {
		(!hasTheSailorsSelectionChanged() && !hasTheTimeSlotSelectionChanged()) || isEateriesSlotsLoading
	}
	
	func onAddFriendTapped() {
		showAddFriend = true
	}
	
	func onAddFriendDismiss() {
		showAddFriend = false
	}
	
	private func hasTheSailorsSelectionChanged() -> Bool {
		return Set(filter.guests.map({ $0.reservationGuestId })) != Set(previousBookedSailorIds)
	}
	
	private func hasTheTimeSlotSelectionChanged() -> Bool {
		return selectedTimeSlot.id != previousSlotId
	}
	
	private func updateBooking() async {
		guard let slot = slots.first(where: {$0.id == selectedTimeSlot.id}) else {
			return
		}
		
		await executeOnMain {
			self.screenState = .loading
			self.isBookingCompleted = false
			self.bookSlotErrorMessage = nil
		}
		
		do {
			let previousBookedSailors = availableSailors.filterByReservationGuestIds(previousBookedSailorIds)
			
			let input = UpdateBookingSlotInputModel(sailors: filter.guests,
													activityCode: self.externalId,
													activitySlotCode: selectedTimeSlot.id,
													startDate: slot.startDateTime,
													appointmentLinkId: self.appointmentLinkId,
													previousBookedSailors: previousBookedSailors)
			
			let result = try await UseCaseExecutor.execute {
				try await self.updateBookingSlotUseCase.execute(input: input)
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
		
		await executeOnMain {
			self.screenState = .content
		}
	}
	
	private func loadEateriesSlots() async {
		await executeOnMain {
			self.isEateriesSlotsLoading = true
		}
		
		if let result = await executeUseCase({
			try await self.eateriesSlotsUseCase.execute(input: self.filter)
		}) {
			if let slots = result.restaurants.first?.slots {
				await executeOnMain {
					self.slots = slots
					self.availableTimeSlots = slots.map({
						x in .init(id: x.id, text: x.timeText, isHignlighted: x.id == self.previousSlotId)
					})
                    selectFoundSlot()
				}
			}
		}
		
		await executeOnMain {
			self.isEateriesSlotsLoading = false
		}
	}
	
	private func loadAvailableSailors(useCache: Bool = true) async {
		if let result = await executeUseCase({
			try await self.mySailorsUseCase.execute(useCache: useCache, appointmentLinkId: self.appointmentLinkId)
		}) {
			await executeOnMain({
				self.availableSailors = result
				self.filter.guests = result.filterByReservationGuestIds(self.previousBookedSailorIds)
			})
		}
	}
	
	private func loadItineraryDates() {
		let itineraryDates = itineraryDatesUseCase.execute()
		self.availableDates = itineraryDates.getDates()
	}

    private func selectFoundSlot() {
        if let foundSlot = availableTimeSlots.first(where: { $0.id == previousSlotId }) {
            self.selectedTimeSlot = foundSlot
        }
    }

	deinit {
		stopObservingEvents()
	}
}

extension EditBookingSheetViewModel {
	// MARK: - Event Handling
	func stopObservingEvents() {
		friendsEventsNotificationService.stopListening(key: listenerKey)
	}
	
	func startObservingEvents() {
		friendsEventsNotificationService.listen(key: listenerKey) { [weak self] in
			guard let self else { return }
			self.handleEvent($0)
		}
	}
	
	private func handleEvent(_ event: FriendsEventNotification) {
		switch event {
		case .friendAdded, .friendRemoved:
			Task {
				await loadAvailableSailors(useCache: false)
			}
		}
	}
}
