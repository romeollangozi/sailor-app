//
//  ReceiptViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 23.11.24.
//

import Foundation

@MainActor
@Observable class ShoreThingReceiptScreenViewModel: BaseViewModelV2, ShoreThingReceiptScreenViewModelProtocol {
    private let getShoreThingReceiptDetailsUseCase: GetShoreThingReceiptDetailsUseCaseProtocol
    private let getMySailorsUseCase: GetMySailorsUseCaseProtocol
    private var bookingEventsNotificationService: BookingEventsNotificationService
    private var listenerKey = "ReceiptViewModel"
    
    private var appointmentId: String
    var screenState: ScreenState = .loading
    var bookingSheetViewModel: BookingSheetViewModel? = nil
    var shoreThingReceipt: ShoreThingReceiptDetails = .empty()
    
    var showPreVoyageEditingStopped: Bool = false
    var showEditBooking: Bool = false
    var availableSailors: [SailorModel] = []
    
    init(appointmentId: String,
         getShoreThingReceiptDetailsUseCase: GetShoreThingReceiptDetailsUseCaseProtocol = GetShoreThingReceiptDetailsUseCase(),
         getMySailorsUseCase: GetMySailorsUseCaseProtocol = GetMySailorsUseCase(),
         bookingEventsNotificationService: BookingEventsNotificationService = .shared
    ) {
        self.appointmentId = appointmentId
        self.getShoreThingReceiptDetailsUseCase = getShoreThingReceiptDetailsUseCase
        self.getMySailorsUseCase = getMySailorsUseCase
        self.bookingEventsNotificationService = bookingEventsNotificationService
        
        super.init()
    }
    
    func onAppear() async {
        self.startObservingEvents()
        await loadScreenData()
    }
    
    func onRefresh() {
        Task {
            await loadScreenData()
        }
    }
    
    private func loadScreenData() async {
        await loadShoreThingReceiptDetails(appointmentId: self.appointmentId)
        
        await loadAvailableSailors()
        
        self.screenState = .content
    }
    
    private func loadShoreThingReceiptDetails(appointmentId: String) async {
        if let result = await executeUseCase({
            try await self.getShoreThingReceiptDetailsUseCase.execute(appointmentId: appointmentId)
        }) {
            self.shoreThingReceipt = result
        } else {
            self.screenState = .error
        }
    }
    
    private func loadAvailableSailors(useCache: Bool = true) async {
        if let result = await executeUseCase({
            try await self.getMySailorsUseCase.execute(useCache: useCache)
        }) {
            self.availableSailors = result.filterByReservationGuestIds(self.shoreThingReceipt.sailors.getOnlyReservationGuestIds())
        }
    }

	@MainActor func onEditBookingTapped() {
        if shoreThingReceipt.isPreVoyageBookingStopped == true {
            showPreVoyageEditingStopped = true
            return
        }
        bookingSheetViewModel = BookingSheetViewModel(title: shoreThingReceipt.name,
                                                      activityCode: shoreThingReceipt.externalId,
                                                      bookableType: .shoreExcursion,
                                                      price: shoreThingReceipt.price,
                                                      currencyCode: shoreThingReceipt.currencyCode,
                                                      categoryCode: shoreThingReceipt.categoryCode,
                                                      slots: shoreThingReceipt.slots,
                                                      initialSlotId: shoreThingReceipt.selectedSlot.id,
                                                      initialSailorIds: shoreThingReceipt.sailors.map({$0.reservationGuestId}),
                                                      appointmentLinkId: shoreThingReceipt.linkId,
                                                      appointmentId: shoreThingReceipt.id,
                                                      isWithinCancellationWindow: shoreThingReceipt.isWithinCancellationWindow,
                                                      locationString: shoreThingReceipt.location,
                                                      bookableImageName: shoreThingReceipt.pictogramUrl,
                                                      actionHandlers: .init(
                                                        onBookingCanceled: {
                                                            self.showEditBooking = false
                                                            self.executeNavigationCommand(HomeTabBarCoordinator.OpenDiscoverShorexListCommand())
                                                        }
                                                      ))
        self.navigationCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.setupPaths(paths: [.landing])
        showEditBooking = true
    }

    func onDisappear() {
        stopObservingEvents()
    }

    func onViewAllTapped() {
        executeNavigationCommand(HomeTabBarCoordinator.OpenDiscoverShorexListCommand())
    }
}

// MARK: - Event Handling
extension ShoreThingReceiptScreenViewModel {

    private func startObservingEvents() {
        bookingEventsNotificationService.listen(key: listenerKey) { [weak self] event in
            guard let self else { return }
            self.handleEvent(event)
        }
    }

    private func stopObservingEvents() {
        bookingEventsNotificationService.stopListening(key: listenerKey)
    }

    private func handleEvent(_ event: BookingEventNotification) {
        switch event {
        case .userDidUpdateABooking(_,_, let appointmentId):
            Task {
                self.appointmentId = appointmentId // Update newly generated id
                self.screenState = .loading
                await loadScreenData()
            }
        default: break
        }
    }
}
