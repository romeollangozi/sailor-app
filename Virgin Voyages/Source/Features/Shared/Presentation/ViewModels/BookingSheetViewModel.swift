//
//  BookingSheetViewModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 29.4.25.
//

import Foundation

protocol SailorSelectionStrategy {
	func filter(_ sailors: [SailorModel]) -> [SailorModel]
}

struct NoRestrictionStrategy: SailorSelectionStrategy {
	func filter(_ sailors: [SailorModel]) -> [SailorModel] {
		return sailors
	}
}

struct OnlyCabinMatesStrategy: SailorSelectionStrategy {
	func filter(_ sailors: [SailorModel]) -> [SailorModel] {
		return sailors.onlyCabinMates()
	}
}

struct OnlyLoggedInSailorStrategy: SailorSelectionStrategy {
	func filter(_ sailors: [SailorModel]) -> [SailorModel] {
		return sailors.onlyLoggedInSailor()
	}
}

@Observable class BookingSheetViewModel: BaseViewModelV2, BookingSheetViewModelProtocol {

	private let mySailorsUseCase: GetMySailorsUseCaseProtocol
	private let itineraryDatesUseCase : GetItineraryDatesUseCaseProtocol
	private let bookActivityUseCase: BookActivityUseCaseProtocol
	private var getBookableConflictsUseCase: GetBookableConflictsUseCaseProtocol
	nonisolated private let friendsEventsNotificationService: FriendsEventsNotificationService
	private let listenerKey = "BookingSheetViewModel"
	private let getLineUpUseCase: GetLineUpUseCaseProtocol
	private let localizationManager: LocalizationManagerProtocol
	
	private let slots: [Slot]
	private var initialSlotId: String?
	private var appointmentLinkId: String?
	private var initialSailorIds: [String]
	private var eligibleGuestIds: [String]
	private let categoryCode: String
	private let activityCode: String
	private var isLimitedAvailability: Bool
	private var description: String? = nil
	private let bookableType: BookableType
	private let price: Double?
	private let currencyCode: String?
	private let previousBookedSlotId: String?
	private let sailorSelectionStrategy: SailorSelectionStrategy
	
    var appointmentId: String?
	var title: String
	var screenState: ScreenState = .loading
	
	var availableSailors: [SailorModel] = []
	var warningForSailors: [SailorModel] = []
	var selectedSailors: [SailorModel] = []

	var previousBookedSailorIds: [String]
	
	var availableDates: [Date] = []
	var disabledDates: [Date] = []
	var itineraryDates: [Date] = []
	var selectedDay: Date = Date()
	var availableTimeSlots: [TimeSlotOptionV2] = []
	
	var selectedTimeSlot: TimeSlotOptionV2 = .empty
	var isSingleSelection: Bool = false
	var isBookingCompleted: Bool = false
	var isCancelCompleted: Bool = false
	var isWithinCancellationWindow: Bool = false
	
	var bookErrorMessage: String? = nil
	var cancelErrorMessage: String? = nil
	
	var isEditFlow: Bool = false
	var isCancelBookSlotLoading: Bool = false
	
	var showBookingCancellationConfirmation: Bool = false
	
	var bookedSailors: [SailorModel] = []
	
	var conflict: BookableConflictsModel? = nil
	var showClarificationStatesSheet: Bool = false
	var showAddNewSailorButton: Bool
	var showPreviewMyAgendaSheet: Bool

	var isPreviewMyAgendaVisible: Bool {
		return !isEditFlow && bookableType != .addOns
	}

	var labels: BookingSheet.Labels {
		.init(bookingNotAllowed: localizationManager.getString(for: .bookingModalDescription))
	}

	private enum BookingButtonText {
		static let limitedAvailability = "Limited Availability"
		static let editDetails = "Edit details"
		static let selectBookingDetails = "Select Booking Details"
		static let next = "Next"
        static let confirmPayment = "Confirm Payment"
	}

	private enum ErrorMessage {
		static let invalidTimeSlot = "Please select a valid time slot"
		static let genericBookingError = "An error occurred while booking, please try again."
	}

	var notAllowedSailors: [SailorModel] {
		if eligibleGuestIds.isEmpty { return [] }
		let notAllowedSailors = availableSailors.filter { sailor in
			!self.eligibleGuestIds.contains(sailor.guestId)
		}
		return notAllowedSailors
	}

	private var canProceedWithBooking: Bool {
		!selectedSailors.isEmpty &&
		(slots.isEmpty || selectedTimeSlot != .empty) &&
		hasTheUserMadeAnyChanges() &&
		!isLimitedAvailability
	}

	struct ActionHandlers {
		var onBookingCanceled: VoidCallback?
				
		init(onBookingCanceled: VoidCallback? = nil) {
			self.onBookingCanceled = onBookingCanceled
		}
	}
	
	var isNextButtonLoading: Bool = false
	var actionHandlers: ActionHandlers
    
    let locationString: String?
    let bookableImageName: String?
    let categoryString: String?

	init(
		title: String,
		activityCode: String,
		bookableType: BookableType,
		price: Double? = nil,
		currencyCode: String? = nil,
		description: String? = nil,
		categoryCode: String = "",
		slots: [Slot] = [],
		initialSlotId: String? = nil,
		initialSailorIds: [String] = [],
		showAddNewSailorButton: Bool = true,
		appointmentLinkId: String? = nil,
        appointmentId: String? = nil,
		isWithinCancellationWindow: Bool = false,
		isSingleSelection: Bool = false,
		sailorSelectionStrategy: SailorSelectionStrategy = NoRestrictionStrategy(),
        locationString: String? = nil,
        bookableImageName: String? = nil,
        categoryString: String? = nil,
		showPreviewMyAgendaSheet: Bool = false,
		eligibleGuestIds: [String] = [],
		actionHandlers: ActionHandlers = ActionHandlers(),
		mySailorsUseCase: GetMySailorsUseCaseProtocol = GetMySailorsUseCase(),
		itineraryDatesUseCase: GetItineraryDatesUseCaseProtocol = GetItineraryDatesUseCase(),
		bookActivityUseCase: BookActivityUseCaseProtocol = BookActivityUseCase(),
		getBookableConflictsUseCase: GetBookableConflictsUseCaseProtocol = GetBookableConflictsUseCase(),
		friendsEventsNotificationService : FriendsEventsNotificationService = FriendsEventsNotificationService(),
		getLineUpUseCase: GetLineUpUseCaseProtocol = GetLineUpUseCase(),
		localizationManager: LocalizationManagerProtocol = LocalizationManager.shared
	) {
        let previousBookedSlotId = appointmentLinkId != nil ? initialSlotId : nil
        let previousBookedSailorIds = appointmentLinkId != nil ? initialSailorIds : []
        let isEditFlow = appointmentLinkId != nil

        self.appointmentId = appointmentId
		self.title = title
		self.activityCode = activityCode
		self.bookableType = bookableType
		self.price = price
		self.currencyCode = currencyCode
		self.description = description
		self.slots = slots
		self.categoryCode = categoryCode
		self.initialSlotId = initialSlotId
		self.previousBookedSlotId = previousBookedSlotId
		self.initialSailorIds = initialSailorIds
		self.previousBookedSailorIds = previousBookedSailorIds
		self.appointmentLinkId = appointmentLinkId
		self.isEditFlow = isEditFlow
		self.actionHandlers = actionHandlers
		self.isWithinCancellationWindow = isWithinCancellationWindow
        self.showAddNewSailorButton = showAddNewSailorButton
		self.sailorSelectionStrategy = sailorSelectionStrategy
		self.description = description
		self.isLimitedAvailability = false
		self.showPreviewMyAgendaSheet = showPreviewMyAgendaSheet
        self.locationString = locationString
        self.bookableImageName = bookableImageName
        self.categoryString = categoryString
		self.isSingleSelection = isSingleSelection
		self.eligibleGuestIds = eligibleGuestIds

		self.bookActivityUseCase = bookActivityUseCase
		self.mySailorsUseCase = mySailorsUseCase
		self.itineraryDatesUseCase = itineraryDatesUseCase
		self.getBookableConflictsUseCase = getBookableConflictsUseCase
		self.friendsEventsNotificationService = friendsEventsNotificationService
		self.getLineUpUseCase = getLineUpUseCase
		self.localizationManager = localizationManager
		super.init()
		self.startObservingEvents()
	}
	
	deinit {
		stopObservingEvents()
    }

	// MARK: - Event Handling
	nonisolated func stopObservingEvents() {
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
				_ = await loadAvailableSailors(useCache: false)
				
				await loadConflicts()
			}
		}
	}
	
	func onFirstAppear() {
		Task {
			await loadScreenData()
		}
	}
	
	func onReAppear() {
		Task{
			await loadAvailableSailors(useCache: false)
		}
	}
	
	func onRefresh() {
		Task {
			await loadScreenData()
		}
	}
	
	private func loadScreenData() async {
		let loaded = await loadAvailableSailors(useCache: true)
		if !loaded {
			self.screenState = .error
			return
		}
		
		await prepareScreenAfterLoadingSailors()
	}
	
	private func prepareScreenAfterLoadingSailors() async {
		selectSailors()

		await prepareBookingAndSlotSelection()
	}

	private func prepareBookingAndSlotSelection() async {
		if slots.isEmpty {
			await handleEmptySlots()
			return
		}

		loadAvailableDates()

		await selectInitialOrFirstAvailableSlot()

		await loadConflicts()

		self.screenState = .content
	}
	
	private func selectInitialOrFirstAvailableSlot() async {
		if let found = slots.findById(for: initialSlotId ?? "") {
			selectedDay = found.startDateTime
			loadSlotsForSelectedDay()
			selectedTimeSlot = .init(id: found.id, text: found.timeText)
		} else {
			selecteFirstOrCurrentDay()
			loadSlotsForSelectedDay()
		}
	}
	
	private func handleEmptySlots() async {
		self.screenState = .content
	}
	
	private func selectSailors() {
	    if initialSailorIds.isEmpty {
	        // If there are no initial sailor IDs, select only the logged-in sailor.
	        selectedSailors = availableSailors.onlyLoggedInSailor()
	    } else {
	        // Otherwise, select sailors matching the initial IDs.
	        selectedSailors = availableSailors.filter { initialSailorIds.contains($0.reservationGuestId) }
	    }
	}
	
	private func selecteFirstOrCurrentDay() {
		if let matchingDate = availableDates.first(where: { isSameDay(date1: $0, date2: Date())}) {
			selectedDay = matchingDate
		} else {
			selectedDay = availableDates.first ?? Date()
		}
	}
	
	func onCancelTapped() {
		showBookingCancellationConfirmation = true
	}
	
	func cancelAppointment(guests: Int) async -> Bool {
		self.cancelErrorMessage = nil

		guard let slotToCancel = slots.findById(for: initialSlotId ?? "") else {
			self.cancelErrorMessage = ErrorMessage.invalidTimeSlot
			return false
		}
		
		self.cancelErrorMessage = nil
		self.isCancelBookSlotLoading = true

        let input = createCancelAppointmentInput(guests: guests, slotToCancel: slotToCancel)
		
		do {
			let result = try await UseCaseExecutor.execute {
				try await self.bookActivityUseCase.execute(input: input)
			}
			
			if case .success = result {

				await refreshBookablesCache()
				
				self.isCancelCompleted = true
				self.isCancelBookSlotLoading = false

				return true
			}
		} catch let error as VVError {
			if case let VVDomainError.error(_, message) = error {
				self.cancelErrorMessage = message
			} else if case let VVDomainError.validationError(error) = error {
				self.cancelErrorMessage = error.errors.joined()
			} else {
				super.handleError(error)
			}
		} catch {
			self.cancelErrorMessage = ErrorMessage.genericBookingError
		}
		
		self.isCancelBookSlotLoading = false

		return false
	}

	private func getUsersToCancel(guests: Int) -> [SailorModel] {
		if guests == 1 {
			return availableSailors.onlyLoggedInSailor()
		} else {
			return availableSailors.filterByReservationGuestIds(self.initialSailorIds)
		}
	}

    private func getPreviousBookedSailors() -> [SailorModel] {
        return availableSailors.filterByReservationGuestIds(previousBookedSailorIds)
    }
	
	private func createCancelAppointmentInput(guests: Int, slotToCancel: Slot) -> BookActivityInputModel {
		let usersToCancel = getUsersToCancel(guests: guests)
		return BookActivityInputModel(activityCode: self.activityCode,
									  categoryCode: self.categoryCode,
									  currencyCode: self.currencyCode ?? "",
									  totalAmount: getTotalAmount() ?? 0,
									  slot: slotToCancel,
									  sailors: usersToCancel,
									  operationType: .cancel,
									  bookableType: self.bookableType,
									  appointmentId: self.appointmentId,
									  appointmentLinkId: self.appointmentLinkId,
									  previousBookedSailors: getPreviousBookedSailors())
	}
	
	private func refreshBookablesCache() async {
		if bookableType == .entertainment {
			_ = try? await getLineUpUseCase.execute(useCache: false)
		}
	}
	
	private var newSailorsCount: Int {
		max(0, selectedSailors.count - previousBookedSailorIds.count)
	}

	private func getTotalAmount() -> Double? {
		guard newSailorsCount > 0, let price = price else { return nil }
		return price * Double(newSailorsCount)
	}

	func viewInYourAgendaTapped() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
			guard let self = self else { return }
			self.navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: self.selectedDay))
		}
	}

	func onPreviewAgendaTapped() {
		self.showPreviewMyAgendaSheet = true
	}

	func onPreviewMyAgendaDismiss() {
		self.showPreviewMyAgendaSheet = false
	}
	
	func onCancellationFlowFinished() {
		showBookingCancellationConfirmation = false
		isCancelCompleted = true
		actionHandlers.onBookingCanceled?()
	}
	
	func onCancellationFlowDismiss() {
		showBookingCancellationConfirmation = false
	}
	
	func onDaySelectionChanged() {
		loadSlotsForSelectedDay()
		
		Task {
			await loadConflicts()
		}
	}
	
	func onSailorSelectionChanged() {
		updateSlotInventoryAvailability()
		
		Task {
			await loadConflicts()
		}
	}
	
	private func updateSlotInventoryAvailability() {
		//In case of add-ons we do not have any slots so we do not need to check for availability
		if slots.isEmpty {
			return
		}
		
		let slots = slots.findByDate(for: selectedDay)
		
		isLimitedAvailability = !slots.hasSlotsWithInventoryGreaterThanOrEqualTo(selectedSailors.count)
		
		if isLimitedAvailability {
			selectedTimeSlot = .empty
		}
	}
	
	func onTimeSlotSelectionChanged() {
		Task {
			await loadConflicts()
		}
	}
	
	func isNextButtonDisabled() -> Bool {
		!canProceedWithBooking
	}
    
    private var shouldConfirmBookingWithoutShowingPaymentSummary: Bool {
        if bookableType == .treatment && isEditFlow {
            if !hasTheSailorsSelectionChanged() {
                return true
            }
        }
        return false
    }
	
	func getBookingButtonText() -> String {
        
        if shouldConfirmBookingWithoutShowingPaymentSummary {
            return BookingButtonText.confirmPayment
        }
        
		if isLimitedAvailability {
			return BookingButtonText.limitedAvailability
		}
		
		if !canProceedWithBooking {
			return isEditFlow ? BookingButtonText.editDetails : BookingButtonText.selectBookingDetails
		}
		
		return BookingButtonText.next
	}
	
	func onNextTapped() {
		if isNonInventoried() || shouldConfirmBookingWithoutShowingPaymentSummary {
			Task {
				await saveBookingWithButtonLoading()
			}
		} else {
			/* The slot can be empty in case of add-ons!*/
			let slotToBook = slots.findById(for: selectedTimeSlot.id) ?? Slot.empty()
			Task {
				await moveToSummaryScreen(slotToBook: slotToBook)
			}
		}
	}
	
	private func moveToSummaryScreen(slotToBook: Slot) async {
        let summaryInput = BookingSummaryInputModel(
            appointmentId: self.appointmentId.value,
            appointmentLinkId: self.appointmentLinkId,
            slot: slotToBook,
            name: self.title,
            location: self.locationString,
            sailors: self.selectedSailors,
            previousBookedSailors: getPreviousBookedSailors(),
            totalPrice: self.getTotalAmount(),
            currencyCode: self.currencyCode ?? "",
            activityCode: self.activityCode,
            categoryCode: self.categoryCode,
            bookableImageName: self.bookableImageName,
			bookableType: self.bookableType,
			addonSellType: nil,
            categoryString: self.categoryString,
            itemDescriptionString: description
        )
                
        self.navigationCoordinator.executeCommand(PurchaseSheetCoordinator.OpenAddOnPurchaseSummaryV2Command(summaryInput: summaryInput))

	}
	
	func isNonInventoried() -> Bool {
		return price == nil
	}
	
	private func isPaidInventoried() -> Bool {
		return price != nil && price! > 0
	}

	private func hasTheUserMadeAnyChanges() -> Bool {
		hasTheSlotSelectionChanged() || hasTheSailorsSelectionChanged()
	}
	
	private func hasTheSailorsSelectionChanged() -> Bool {
		return Set(selectedSailors.getOnlyReservationGuestIds()) != Set(previousBookedSailorIds)
	}
	
	private func hasTheSlotSelectionChanged() -> Bool {
		return selectedTimeSlot.id != previousBookedSlotId
	}
	
	func getDescriptionText() -> String? {
		/*
		 There are cases where description is defined for example in add-ons.
		 In this case we use that instead of the calculated description based on slot and sailor selection
		 */
		if let description = description {
			return description
		}
		
		guard let slotToBook = slots.findById(for: selectedTimeSlot.id) else {
			return nil
		}
		
		let peopleText = "for \(selectedSailors.count) \(selectedSailors.count == 1 ? "person" : "people")"
		return "\(slotToBook.startDateTime.dayAndTimeFormattedString()) \(peopleText)"
	}
	
	func onClarificationStatesSheetDismiss() {
		self.showClarificationStatesSheet = false
	}
	
	func onClarificationsButtonTapped() {
		self.showClarificationStatesSheet = true
	}
	
	func getSlotBookedTitle() -> String {
		guard let slotToBook = slots.findById(for: selectedTimeSlot.id) else {
			return ""
		}
	
		return "\(title) \(slotToBook.startDateTime.dayAndTimeFormattedString())"
	}
	
	func getTotalPriceFormatted() -> String? {
		if let totalPrice = getTotalAmount(), let currencyCode = currencyCode, !currencyCode.isEmpty {
			return "\(currencyCode.currencySign) \(totalPrice.toCurrency())"
		}
		
		return nil
	}
	
	private func loadAvailableSailors(useCache: Bool) async -> Bool {
		if let result = await executeUseCase({
			try await self.mySailorsUseCase.execute(useCache: useCache, appointmentLinkId: self.appointmentLinkId)
		}) {
			let allMySailors = result
			self.availableSailors = self.sailorSelectionStrategy.filter(allMySailors)
			return true
		}
		return false
	}
	
	private func loadAvailableDates() {
		self.itineraryDates = itineraryDatesUseCase.execute().getDates()
		self.availableDates = slots.uniqueDates()
		self.disabledDates = self.itineraryDates.exclude(availableDates)
	}
	
	private func loadSlotsForSelectedDay() {
		availableTimeSlots = []
		
        let slotsPerDay = slots.findActiveByDate(for: selectedDay, isEditFlow: isEditFlow)
		
		slotsPerDay.forEach { slot in
			availableTimeSlots.append(.init(id: slot.id,
											text: slot.timeText,
											isDisabled: selectedSailors.count > slot.inventoryCount,
											isHignlighted: slot.id == previousBookedSlotId))
		}
		
		if availableTimeSlots.count > 0 {
			selectedTimeSlot = availableTimeSlots[0]
		}
		
		isLimitedAvailability = !slotsPerDay.hasSlotsWithInventoryGreaterThanOrEqualTo(selectedSailors.count)
	}
	
	private func saveBooking() async {
		self.bookErrorMessage = nil

		guard let slotToBook = slots.findById(for: selectedTimeSlot.id) else {
			self.bookErrorMessage = ErrorMessage.invalidTimeSlot

			return
		}
		
		self.screenState = .loading
		self.isBookingCompleted = false

		let input = makeBookingInput(slotToBook: slotToBook)
		
		await performBooking(input: input)
		
		self.screenState = .content
	}
    
    // This function is the same as saveBooking()
    // Instead of setting the full screen to loading state, we change the button state only.
    private func saveBookingWithButtonLoading() async {
        
        self.bookErrorMessage = nil

        guard let slotToBook = slots.findById(for: selectedTimeSlot.id) else {
            self.bookErrorMessage = ErrorMessage.invalidTimeSlot
            return
        }
        
        self.isNextButtonLoading = true
        let input = makeBookingInput(slotToBook: slotToBook)
        
        await performBooking(input: input)
        
        self.isNextButtonLoading = false
    }

	private func performBooking(input: BookActivityInputModel) async {
		do {
			let result = try await UseCaseExecutor.execute {
				try await self.bookActivityUseCase.execute(input: input)
			}
			
			if case .success = result {
				self.isBookingCompleted = true
			}
		} catch {
			handleBookingError(error)
		}
	}

	private func makeBookingInput(slotToBook: Slot) -> BookActivityInputModel {
		return BookActivityInputModel(activityCode: self.activityCode,
									 categoryCode: self.categoryCode,
									 currencyCode: self.currencyCode ?? "",
									 totalAmount: getTotalAmount() ?? 0,
									 slot: slotToBook,
									 sailors: selectedSailors,
									 operationType: appointmentLinkId != nil ? .edit : .book,
									 bookableType: self.bookableType,
									 appointmentId: self.appointmentId,
									 appointmentLinkId: self.appointmentLinkId,
									 previousBookedSailors: getPreviousBookedSailors())
	}

	private func handleBookingVVError(_ error: VVError) {
		if case let VVDomainError.error(_, message) = error {
			self.bookErrorMessage = message
		} else if case let VVDomainError.validationError(error) = error {
			self.bookErrorMessage = error.errors.joined()
		} else {
			super.handleError(error)
		}
	}

    private func getSailorsToCheckForConflict(excludedSailors: [String]) -> [BookableConflictsInputModel.Sailor] {
        return availableSailors
            .filter { !excludedSailors.contains($0.reservationGuestId) }
            .map { .init(reservationNumber: $0.reservationNumber, reservationGuestId: $0.reservationGuestId) }
    }
	
	private func filterAvailableSailors(byGuestIds ids: [String]) -> [SailorModel] {
		return availableSailors.filterByReservationGuestIds(ids)
	}

	private func loadConflicts() async {
		//We do not need to run conflicts for non-inventoried bookings
		if isNonInventoried() {
			return
		}
		
		guard let slotToBook = slots.findById(for: selectedTimeSlot.id) else {
			return
		}
		
		self.conflict = nil

		//On edit flow if the slot has not changed then we need to exclude the sailors that are already booked because the previous booked slot has changed!
		let excludedSailorsFromConflict = hasTheSlotSelectionChanged() ? [] : previousBookedSailorIds
		
		let sailorsToCheckForConflict = getSailorsToCheckForConflict(excludedSailors: excludedSailorsFromConflict)
		
		if sailorsToCheckForConflict.isEmpty {
			return
		}
		
		self.warningForSailors = []
		self.bookedSailors = []
		self.availableTimeSlots = self.availableTimeSlots.clearAllSlotsFromWarning()
		self.isNextButtonLoading = true

		let input = makeBookableConflictsInputModel(slotToBook: slotToBook, sailorsToCheckForConflict: sailorsToCheckForConflict)
		
		if let conflicts = await executeUseCase({
			try await self.getBookableConflictsUseCase.execute(input: input)
		}) {
			if let conflictsForSlot = conflicts.first(where: { $0.slotId == slotToBook.id }) {
				self.bookedSailors = filterAvailableSailors(byGuestIds: conflictsForSlot.getSailorsIdsInBookedConflict())
				self.selectedSailors = self.selectedSailors.exclude(self.bookedSailors)
				self.warningForSailors = filterAvailableSailors(byGuestIds: conflictsForSlot.getSailorsIdsInHardConflict())
				self.conflict = conflictsForSlot

				if conflictsForSlot.hasAtLeatOneSailorInHardConflict() {
					self.availableTimeSlots = availableTimeSlots.markTimeSlotsWithWarning([slotToBook.id])
				}
			}
		}
		
		self.isNextButtonLoading = false
	}

    private func handleBookingError(_ error: Error) {
        if let vvError = error as? VVError {
            handleBookingVVError(vvError)
        } else {
            self.bookErrorMessage = ErrorMessage.genericBookingError
        }
    }

    private func makeBookableConflictsInputModel(slotToBook: Slot, sailorsToCheckForConflict: [BookableConflictsInputModel.Sailor]) -> BookableConflictsInputModel {
        return BookableConflictsInputModel(
            sailors: sailorsToCheckForConflict,
            slots: [
                .init(id: slotToBook.id, startDateTime: slotToBook.startDateTime, endDateTime: slotToBook.endDateTime)
            ],
            activityCode: self.activityCode,
            isActivityPaid: isPaidInventoried(),
            activityGroupCode: self.categoryCode,
            appointmentLinkId: self.appointmentLinkId ?? ""
        )
    }
}

