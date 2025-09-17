//
//  TreatmentDetailsScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 5.2.25.
//

import SwiftUI
import VVUIKit
import Foundation

@Observable class TreatmentDetailsScreenViewModel: BaseViewModel, TreatmentDetailsScreenViewModelProtocol {
    private let getTreatmentDetailsUseCase: GetTreatmentDetailsUseCaseProtocol
    private var bookingEventsNotificationService: BookingEventsNotificationService
    private var listenerKey = "TreatmentDetailsScreenViewModel"
    
    var screenState: ScreenState = .loading
    var bookButtonLoading: Bool = false
    var showcancellationFlow: Bool = false
    var isPurchaseSheetPresented: Bool = false
    var showPreVoyageBookingStopped: Bool = false
    var treatmentId: String
    var shouldScroll: Bool = false
    var treatmentDetails: TreatmentDetails = TreatmentDetails.empty()
    var bookingSheetViewModel: BookingSheetViewModel? = nil
    
    init(
        treatmentId: String,
        getTreatmentDetailsUseCase: GetTreatmentDetailsUseCaseProtocol = GetTreatmentDetailsUseCase(),
        bookingEventsNotificationService: BookingEventsNotificationService = .shared
    ) {
        self.treatmentId = treatmentId
        
        self.getTreatmentDetailsUseCase = getTreatmentDetailsUseCase
        self.bookingEventsNotificationService = bookingEventsNotificationService
        
        super.init()
        self.startObservingEvents()
    }
    
    deinit {
        stopObservingEvents()
    }
    
    func hideCancellation() {
        self.showcancellationFlow = false
    }
    
    var productType: TreatmentProductType {
        if treatmentDetails.options.count > 1 {
            return .multipleProduct
        }
        
        if treatmentDetails.options.count == 1 {
            return .singleProduct
        }
        
        return .noProduct
    }
    
    var isSoldOutPassedClosed: Bool {
        return treatmentDetails.status == .soldOut ||
        treatmentDetails.status == .passed ||
        treatmentDetails.status == .closed
    }
    
    var isAvailable: Bool {
        return treatmentDetails.status == .available
    }
    
    var shouldShowPriceMessageBar: Bool {
        return isAvailable
    }
    
    var shouldShowStatusMessageBar: Bool {
        return treatmentDetails.status == .soldOut ||   treatmentDetails.status == .closed
    }
    
    var grayscale: Double {
        return (isAvailable || productType == .noProduct) ? 0.0 : 1.0
    }
    
    var messageBarFullWidth: Bool {
        return isAvailable ? false : true
    }
    
    var messageBarStyle: MessageBarStyle {
        if treatmentDetails.status == .soldOut || treatmentDetails.status == .closed {
            return MessageBarStyle.Dark
        }
        if treatmentDetails.status == .available {
            return MessageBarStyle.Purple
        }
        return MessageBarStyle.Dark
    }
    
    var messageBarText: String {
        switch treatmentDetails.status {
        case .soldOut:
            return "\(treatmentDetails.priceFormatted) | SOLD OUT"
        case .closed:
            return "\(treatmentDetails.priceFormatted) | BOOKING CLOSED"
        case .available:
            return "\(treatmentDetails.priceFormatted)"
        default:
            return ""
        }
    }
    
    func optionButtonText(for option: TreatmentOption) -> String {
        switch option.status {
        case .soldOut:
            return "SOLD OUT"
        case .closed:
            return "BOOKING CLOSED"
        case .available:
            return "\(option.priceFormatted)"
        default:
            return ""
        }
    }
    
    func onAppear() {
        Task {
            await loadTreatmentDetails(treatmentId: treatmentId)
        }
    }
    
    func onRefresh() {
        Task {
            await loadTreatmentDetails(treatmentId: treatmentId)
        }
    }
    
	@MainActor func book() {
        guard let firstOption = self.treatmentDetails.options.first else { return }
        
        book(treatmentOption: firstOption)
    }
    
	@MainActor func book(treatmentOption: TreatmentOption) {
        if treatmentOption.isPreVoyageBookingStopped {
            showPreVoyageBookingStopped = true
            return
        }
        let location = treatmentDetails.location.isEmpty ? nil : treatmentDetails.location
		
        bookingSheetViewModel = BookingSheetViewModel(title: treatmentDetails.name,
                                                      activityCode: treatmentOption.id,
                                                      bookableType: .treatment,
                                                      price: treatmentOption.price,
                                                      currencyCode: treatmentOption.currencyCode,
                                                      categoryCode: treatmentOption.categoryCode,
                                                      slots: treatmentOption.slots,
                                                      showAddNewSailorButton: false,
                                                      appointmentId: treatmentOption.id,
                                                      sailorSelectionStrategy: OnlyLoggedInSailorStrategy(),
                                                      locationString: location)
        self.navigationCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.setupPaths(paths: [.landing])
        isPurchaseSheetPresented = true
    }

    private func loadTreatmentDetails(treatmentId: String) async {
        if let result = await executeUseCase({
            try await self.getTreatmentDetailsUseCase.execute(treatmentId: treatmentId)
        }) {
            await executeOnMain({
                self.treatmentDetails = result
                self.screenState = .content
            })
        } else {
            await executeOnMain({
                self.screenState = .error
            })
        }
    }
}

// MARK: - Event Handling
extension TreatmentDetailsScreenViewModel {
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
        case .userDidMakeABooking, .userDidCancelABooking:
            refreshTreatmentDetails()
        default: break
        }
    }
    
    private func refreshTreatmentDetails() {
        Task {
            await self.loadTreatmentDetails(treatmentId: self.treatmentId)
        }
    }
}

