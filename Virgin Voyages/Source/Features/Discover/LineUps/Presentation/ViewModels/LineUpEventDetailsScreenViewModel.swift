//
//  LineUpEventDetailsScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 17.1.25.
//

import VVUIKit
import Foundation

@Observable class LineUpEventDetailsScreenViewModel: BaseViewModel, LineUpEventDetailsScreenViewModelProtocol {
    private let lineUpDetailsUseCase: GetLineUpDetailsUseCaseProtocol
    
    var screenState: ScreenState = .loading
    var event: LineUpEvents.EventItem
    var showPreVoyageBookingStopped: Bool = false
    var showBookEventSheet: Bool = false
    var bookingSheetViewModel: BookingSheetViewModel? = nil
    
    // MARK: - Booking Events
    private var bookingEventsNotificationService: BookingEventsNotificationService
    private var listenerKey = "LineUpEventDetailsScreenViewModel"
    
    init(event: LineUpEvents.EventItem,
         bookingEventsNotificationService: BookingEventsNotificationService = .shared,
         lineUpDetailsUseCase: GetLineUpDetailsUseCaseProtocol = GetLineUpDetailsUseCase()) {
        
        self.event = event
        self.bookingEventsNotificationService = bookingEventsNotificationService
        self.lineUpDetailsUseCase = lineUpDetailsUseCase
        
        super.init()
        self.startObservingEvents()
    }
    
    func onAppear() {
		screenState = .content
        Task{
            await self.loadEditorialBlocks()
        }
    }
    
    func onRefresh() {
		screenState = .content
        Task{
            await self.loadEditorialBlocks()
        }
    }
    
	@MainActor func addToAgenda() {
        if event.isPreVoyageBookingStopped {
            showPreVoyageBookingStopped = true
            return
        }
        
        bookingSheetViewModel = BookingSheetViewModel(title: event.name,
                                                      activityCode: event.eventID,
                                                      bookableType:.entertainment,
                                                      price: event.inventoryState != .nonInventoried ? event.price : nil,
                                                      currencyCode: event.currencyCode,
                                                      categoryCode: event.categoryCode,
                                                      slots: event.slots,
                                                      initialSlotId: event.selectedSlot?.id,
                                                      appointmentId: event.eventID,
                                                      locationString: event.location)
        self.navigationCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.setupPaths(paths: [.landing])
        showBookEventSheet = true
    }
    
    func navigateBack() {
        navigationCoordinator.discoverCoordinator.navigationRouter.navigateBack()
    }
    
    deinit {
        stopObservingEvents()
    }
    
    private func loadEventDetails(eventId: String, slotId: String) async {
        if let result = await executeUseCase({
            try await self.lineUpDetailsUseCase.execute(eventId: eventId, slotId: slotId)
        }) {
            await executeOnMain {
                self.event = result
            }
        }
    }
}

// MARK: - Event Handling
extension LineUpEventDetailsScreenViewModel {
    
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
        case .userDidMakeABooking(let activityCode, let activitySlotCode), .userDidUpdateABooking(let activityCode, let activitySlotCode, _):
            Task {
                await self.loadEventDetails(eventId: activityCode, slotId: activitySlotCode)
                await self.loadEditorialBlocks()
            }
        default: break
        }
    }
    
    @MainActor
    func loadEditorialBlocks() async {
        var loadedBlocks: [EditorialBlock] = []

        for url in event.editorialBlocks {
            let html = await fetchRawHTML(from: url)
            loadedBlocks.append(EditorialBlock(url: url, html: html))
        }

        self.event.editorialBlocksWithContent = loadedBlocks
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
