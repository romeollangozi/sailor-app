//
//  LineUpEventReceiptViewModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.1.25.
//

import Foundation

@MainActor
@Observable class LineUpEventReceiptViewModel: BaseViewModelV2, LineUpEventReceiptScreenViewModelProtocol {
    private let getLineUpAppointmentDetailsUseCase: GetLineUpAppointmentDetailsUseCaseProtocol
    private let lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol
    private let lineUpDetailsUseCase: GetLineUpDetailsUseCaseProtocol
    private let getMySailorsUseCase: GetMySailorsUseCaseProtocol
    
    private var event: LineUpEvents.EventItem = .empty()
    private var appointmentId: String
    // MARK: appointmentId: String
    // Can be overwritten if the appointment/booking is edited.
    // Editing the booking will mark the old booking as closed and generate a new booking with a new appointment id

    
    var screenState: ScreenState = .loading
    var lineUpReceipt: LineUpReceiptModel = LineUpReceiptModel.empty()
    var showPreVoyageBookingStopped: Bool = false
    var showEditFlow: Bool = false
    var bookingSheetViewModel: BookingSheetViewModel? = nil
    var showEditButton: Bool {
        let sailorLocation = lastKnownSailorConnectionLocationRepository.fetchLastKnownSailorConnectionLocation()
        return sailorLocation == .ship ? lineUpReceipt.isEditable : true
    }
    var availableSailors: [SailorModel] = []
    
    // MARK: - Booking Events
    private var bookingEventsNotificationService: BookingEventsNotificationService
    private var listenerKey = "LineUpEventReceiptViewModel"
    
    init(
        appointmentId: String,
        bookingEventsNotificationService: BookingEventsNotificationService = .shared,
        getLineUpAppointmentDetailsUseCase: GetLineUpAppointmentDetailsUseCaseProtocol = GetLineUpAppointmentDetailsUseCase(),
        lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol = LastKnownSailorConnectionLocationRepository(),
        lineUpDetailsUseCase: GetLineUpDetailsUseCaseProtocol = GetLineUpDetailsUseCase(),
        getMySailorsUseCase: GetMySailorsUseCaseProtocol = GetMySailorsUseCase()
    ) {
        self.appointmentId = appointmentId
        self.getLineUpAppointmentDetailsUseCase = getLineUpAppointmentDetailsUseCase
        self.lastKnownSailorConnectionLocationRepository = lastKnownSailorConnectionLocationRepository
        self.bookingEventsNotificationService = bookingEventsNotificationService
        self.lineUpDetailsUseCase = lineUpDetailsUseCase
        self.getMySailorsUseCase = getMySailorsUseCase
        
        super.init()
    }
    
    func onAppear() async {
        self.startObservingEvents()
        await loadScreenData()
        await loadEditorialBlocks()
    }
    
    func onRefresh() {
        Task {
            await loadScreenData()
            await loadEditorialBlocks()
        }
    }
    
    private func loadScreenData() async {
        await loadReceipt()
        
        await loadEventDetails(eventId: lineUpReceipt.eventId, slotId: lineUpReceipt.selectedSlot.id)
        
        await loadAvailableSailors()
        
        self.screenState = .content
    }
    
    private func loadReceipt() async {
        if let result = await executeUseCase({
            try await self.getLineUpAppointmentDetailsUseCase.execute(appointmentId: self.appointmentId)
        }) {
            self.lineUpReceipt = result
        } else {
            
            self.screenState = .error
        }
    }
    
    private func loadAvailableSailors(useCache: Bool = true) async {
        if let result = await executeUseCase({
            try await self.getMySailorsUseCase.execute(useCache: useCache)
        }) {
            self.availableSailors = result.filterByReservationGuestIds(self.lineUpReceipt.sailors.getOnlyReservationGuestIds())
        }
    }
    
	@MainActor func onEditBookingTapped() {
        if lineUpReceipt.isPreVoyageBookingStopped {
            showPreVoyageBookingStopped = true
            return
        }
        
        bookingSheetViewModel = BookingSheetViewModel(title: lineUpReceipt.name,
                                                      activityCode: lineUpReceipt.eventId,
                                                      bookableType:.entertainment,
                                                      price: lineUpReceipt.inventoryState != .nonInventoried ? lineUpReceipt.price : nil,
                                                      currencyCode: lineUpReceipt.currencyCode,
                                                      categoryCode: lineUpReceipt.categoryCode,
                                                      slots: lineUpReceipt.slots,
                                                      initialSlotId: lineUpReceipt.selectedSlot.id,
                                                      initialSailorIds: lineUpReceipt.sailors.getOnlyReservationGuestIds(),
                                                      appointmentLinkId: lineUpReceipt.appointmentLinkId,
                                                      appointmentId: lineUpReceipt.id,
                                                      isWithinCancellationWindow: lineUpReceipt.isWithinCancellationWindow,
                                                      locationString: event.location,
                                                      actionHandlers: .init(
                                                        onBookingCanceled: {
                                                            self.showEditFlow = false
                                                            self.navigateToEventsLineUp()
                                                        }))
        
        self.navigationCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.setupPaths(paths: [.landing])
        showEditFlow = true
        
    }
    
    func onViewAllTapped() {
        navigateToEventsLineUp()
    }
    
    private func navigateToEventsLineUp() {
        executeNavigationCommand(HomeTabBarCoordinator.OpenDiscoverLineUpEventsCommand())
    }
    
    private func loadEventDetails(eventId: String, slotId: String) async {
        if let result = await executeUseCase({
            try await self.lineUpDetailsUseCase.execute(eventId: eventId, slotId: slotId)
        }) {
            self.event = result
            
        } else {
            self.screenState = .error
        }
    }
    
    func onDisappear() {
        stopObservingEvents()
    }

    @MainActor
    func loadEditorialBlocks() async {
        var loadedBlocks: [EditorialBlock] = []

        for url in lineUpReceipt.editorialBlocks {
            let html = await fetchRawHTML(from: url)
            loadedBlocks.append(EditorialBlock(url: url, html: html))
        }

        self.lineUpReceipt.editorialBlocksWithContent = loadedBlocks
    }
    
    func fetchRawHTML(from urlString: String) async -> String? {
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Failed to fetch HTML: \(error)")
            return nil
        }
    }
}

// MARK: - Event Handling
extension LineUpEventReceiptViewModel {
    
    func startObservingEvents() {
        bookingEventsNotificationService.listen(key: listenerKey) { [weak self] event in
            guard let self else { return }
            self.handleEvent(event)
        }
    }
    
    func stopObservingEvents() {
        bookingEventsNotificationService.stopListening(key: listenerKey)
    }
    
    func handleEvent(_ event: BookingEventNotification) {
        switch event {
        case .userDidUpdateABooking(_, _, let appoinmentId):
            Task {
                self.appointmentId = appoinmentId // Update newly generated id
                self.screenState = .loading
                onRefresh()
            }
        default: break
        }
    }
    
}
