//
//  TreatmentReceiptScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 5.2.25.
//

import Foundation
import Observation

@Observable @MainActor class TreatmentReceiptScreenViewModel: BaseViewModelV2, TreatmentReceiptScreenViewModelProtocol {
    private var getTreatmentReceiptUseCase: GetTreatmentReceiptUseCaseProtocol
    private let getTreatmentDetailsUseCase: GetTreatmentDetailsUseCaseProtocol
    private let lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol
    private let getMySailorsUseCase: GetMySailorsUseCaseProtocol
    private var bookingEventsNotificationService: BookingEventsNotificationService
    private var listenerKey = "TreatmentReceiptScreenViewModel"
    
    private var appointmentId: String
    // MARK: appointmentId: String
    // Can be overwritten if the appointment/booking is edited.
    // Editing the booking will mark the old booking as closed and generate a new booking with a new appointment id

    var screenState: ScreenState = .loading
    var treatmentReceiptModel: TreatmentReceiptModel = .empty()
    
    var showEditFlow: Bool = false
    var showPreVoyageBookingStopped: Bool = false
    var bookingSheetViewModel: BookingSheetViewModel? = nil
    var showEditButton: Bool {
        let sailorLocation = lastKnownSailorConnectionLocationRepository.fetchLastKnownSailorConnectionLocation()
        return sailorLocation == .ship ? treatmentReceiptModel.isEditable : true
    }
    var isLoadingReceipt = false
    var availableSailors: [SailorModel] = []
    
    init(
        appointmentId: String,
        getTreatmentReceiptUseCase: GetTreatmentReceiptUseCaseProtocol = GetTreatmentReceiptUseCase.init(),
        getTreatmentDetailsUseCase: GetTreatmentDetailsUseCaseProtocol = GetTreatmentDetailsUseCase(),
        lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol = LastKnownSailorConnectionLocationRepository(),
        getMySailorsUseCase: GetMySailorsUseCaseProtocol = GetMySailorsUseCase(),
        bookingEventsNotificationService: BookingEventsNotificationService = .shared
    ) {
        self.appointmentId = appointmentId
        self.getTreatmentReceiptUseCase = getTreatmentReceiptUseCase
        self.getTreatmentDetailsUseCase = getTreatmentDetailsUseCase
        self.lastKnownSailorConnectionLocationRepository = lastKnownSailorConnectionLocationRepository
        self.getMySailorsUseCase = getMySailorsUseCase
        self.bookingEventsNotificationService = bookingEventsNotificationService
        
        super.init()
        self.startObservingEvents()
    }
    
    func onAppear() {
        Task {
            await loadScreenData()
        }
    }
    
    func editBooking() {
        if treatmentReceiptModel.isPreVoyageBookingStopped {
            showPreVoyageBookingStopped = true
            return
        }
		
		bookingSheetViewModel = BookingSheetViewModel(title: treatmentReceiptModel.name,
													  activityCode: treatmentReceiptModel.treatmentOptionId,
													  bookableType: .treatment,
													  price: treatmentReceiptModel.price,
													  currencyCode: treatmentReceiptModel.currencyCode,
													  categoryCode: treatmentReceiptModel.categoryCode,
													  slots: treatmentReceiptModel.slots,
													  initialSlotId: treatmentReceiptModel.selectedSlot?.id,
													  initialSailorIds: treatmentReceiptModel.sailors.getOnlyReservationGuestIds(),
													  showAddNewSailorButton: false,
													  appointmentLinkId: treatmentReceiptModel.linkId,
                                                      appointmentId: treatmentReceiptModel.id,
													  isWithinCancellationWindow: treatmentReceiptModel.isWithinCancellationWindow,
													  sailorSelectionStrategy: OnlyLoggedInSailorStrategy(),
													  locationString: treatmentReceiptModel.location,
													  actionHandlers: .init(
														onBookingCanceled: {
															self.showEditFlow = false
															self.executeNavigationCommand(HomeTabBarCoordinator.OpenDiscoverTreatmentsListCommand())
														}
													  ))
        self.navigationCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.setupPaths(paths: [.landing])
		showEditFlow = true
	}
	
	func onViewAllTapped() {
		executeNavigationCommand(HomeTabBarCoordinator.OpenDiscoverTreatmentsListCommand())
	}
    
    private func loadScreenData() async {
        await loadReceipt()
                
        await loadAvailableSailors()
        
        self.screenState = .content
    }
	
	private func loadReceipt() async {
        self.isLoadingReceipt = true
		if let result = await executeUseCase({
			try await self.getTreatmentReceiptUseCase.execute(appointmentId: self.appointmentId)
		}) {
            self.treatmentReceiptModel = result
		} else {
            self.screenState = .error
		}
	}
    
    private func loadAvailableSailors(useCache: Bool = true) async {
        if let result = await executeUseCase({
            try await self.getMySailorsUseCase.execute(useCache: useCache)
        }) {
            self.availableSailors = result.filterByReservationGuestIds(self.treatmentReceiptModel.sailors.getOnlyReservationGuestIds())
        }
    }
}

// MARK: - Booking Event Handling
extension TreatmentReceiptScreenViewModel {
    
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
        case .userDidUpdateABooking(_,_, let appointmentId):
            screenState = .loading
			Task {
                self.appointmentId = appointmentId // Update newly generated id
				await loadReceipt()
			}
        default: break
        }
    }
}

