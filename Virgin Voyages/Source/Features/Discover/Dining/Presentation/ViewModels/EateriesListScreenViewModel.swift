//
//  DiningVIewModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 23.11.24.
//

import Foundation

@Observable class EateriesListScreenViewModel : BaseViewModel, EateriesListScreenViewModelProtocol {
	var newBookingViewModel: EaterySlotBookViewModel? = nil
	var editBookingViewModel: EditBookingSheetViewModel? = nil
	
    private let eateriesListUseCase : GetEateriesListUseCaseProtocol
    private let eateriesSlotsUseCase: GetEateriesSlotsUseCaseProtocol
    private let mySailorsUseCase: GetMySailorsUseCaseProtocol
	private let itineraryDatesUseCase : GetItineraryDatesUseCaseProtocol
    private let getSailorDateAndTimeUseCase: GetSailorDateAndTimeUseCaseProtocol
    
	var eateriesWithSlots: EateriesSlots = .empty()
    var filter: EateriesSlotsInputModel = EateriesSlotsInputModel()
    var screenState: ScreenState = .loading
    
    var eateriesList: EateriesList = EateriesList.empty()
    var isEateriesSlotsLoading: Bool = true
    
    var showSlotBookSheet: Bool = false
    var showFilterSheet: Bool = false
    var showEditSlotBookSheet: Bool = false
    var availableSailors: [SailorModel] = []
	var showPreviewMyAgendaSheet: Bool = false
	var itineraryDates: [ItineraryDay] = []
	var showAddTocalendarSheet: Bool = false
	var portNameOrSeaDayText: String? {
		guard let itinerary = itineraryDates.findItinerary(for: filter.searchSlotDate) else {
			return nil
		}
		return itinerary.isSeaDay ? "Sea day" : itinerary.portName
	}
	var errorOnLoadingSlots: Bool = false
    
    private let friendsEventsNotificationService: FriendsEventsNotificationService
    private let listenerKey = "EateriesListScreenViewModel"
    var showSoldOutSheet: Bool = false
    var infoDrawerModel: InfoDrawerModel = .empty()
    private let getSailorShoreOrShipUseCase: GetSailorShoreOrShipUseCaseProtocol

    init(eateriesListUseCase: GetEateriesListUseCaseProtocol = GetEateriesListUseCase(),
         eateriesSlotsUseCase: GetEateriesSlotsUseCaseProtocol = GetEateriesSlotsUseCase(),
		 mySailorsUseCase: GetMySailorsUseCaseProtocol = GetMySailorsUseCase(),
		 itineraryDatesUseCase: GetItineraryDatesUseCaseProtocol = GetItineraryDatesUseCase(),
         getSailorDateAndTimeUseCase: GetSailorDateAndTimeUseCaseProtocol = GetSailorDateAndTimeUseCase(),
         friendsEventsNotificationService: FriendsEventsNotificationService = .shared,
         getSailorShoreOrShipUseCase: GetSailorShoreOrShipUseCaseProtocol = GetSailorShoreOrShipUseCase()) {
        self.eateriesListUseCase = eateriesListUseCase
        self.eateriesSlotsUseCase = eateriesSlotsUseCase
        self.mySailorsUseCase = mySailorsUseCase
		self.itineraryDatesUseCase = itineraryDatesUseCase
        self.getSailorDateAndTimeUseCase = getSailorDateAndTimeUseCase
        self.friendsEventsNotificationService = friendsEventsNotificationService
        self.getSailorShoreOrShipUseCase = getSailorShoreOrShipUseCase

        super.init()
        self.startObservingEvents()
    }
    
	func onFirstAppear() {
		Task {
			await loadScreenData()
			
			await loadEateriesSlots()
		}
	}
	
    func onReAppear() {
		Task {
			await loadEateriesSlots()
		}
    }
    
    func onRefresh() {
		Task {
			await loadScreenData()
			await loadEateriesSlots()
		}
    }
	
	private func loadScreenData() async {
        
        await loadItineraryDates()
		
		await loadEateries()
		
		await loadAvailableSailors(useCache: true)
		
		await executeOnMain({
			self.screenState = .content
		})
	}
    
    func onDateChanged() {
		Task {
			await loadEateriesSlots()
		}
    }
    
    func onFilterChanged(date: Date, mealPeriod: MealPeriod, selectedSailors: [SailorModel]) {
		filter.searchSlotDate = date
		filter.mealPeriod = mealPeriod
		filter.guests = selectedSailors
		
		showFilterSheet = false
		
		Task {
			await loadEateriesSlots()
		}
    }
    
	func onSlotClick(eatery: EateriesSlots.Restaurant, slot: Slot) {
		newBookingViewModel = .init(title: eatery.name,
									activityCode: eatery.externalId,
									slot: slot,
									mealPeriod: filter.mealPeriod,
									selectedSailors: filter.guests,
									disclaimer: eatery.disclaimer)
		
		showSlotBookSheet = true
	}
	
    func onEditEateryWithSlotsButtonClick(eatery: EateriesSlots.Restaurant) {
        if let appointment = eatery.appointment {
            editBookingViewModel = .init(initialSlotId: appointment.slotId,
                                         initialSlotDate: appointment.startDateTime,
                                         externalId: eatery.externalId,
                                         venueId: eatery.venueId,
                                         initialSailorsIds: appointment.sailors,
                                         appointmentLinkId: appointment.linkId,
                                         mealPeriod: filter.mealPeriod,
                                         eateryName: eatery.name,
                                         isWithinCancellationWindow: appointment.isWithinCancellationWindow)
            
            showEditSlotBookSheet = true
            
        }
    }
    
    func onBookCompleted() {
		hideSlotBookSheet()
	
		Task {
			await loadEateriesSlots()
		}
    }
    
	func onNewBookingSheetDismiss() {
		hideSlotBookSheet()
	}
	
    private func hideSlotBookSheet() {
		newBookingViewModel = nil
        showSlotBookSheet = false
    }
    
    func onFilterButtonClick () {
        showFilterSheet = true
    }
    
    func onEditBookingCompleted() {
		hideEditBookSheet()
		
		Task {
			await loadEateriesSlots()
		}
    }
    
	func onEditBookingSheetDismiss() {
		hideEditBookSheet()
	}
	
	func onBookingCanceled() {
		hideEditBookSheet()
		
		Task {
			await loadEateriesSlots()
		}
	}
	
	private func hideEditBookSheet() {
		editBookingViewModel = nil
		showEditSlotBookSheet = false
	}
		
	func onChangePartySize() {
		hideSlotBookSheet()
		showFilterSheet = true
	}
	
	func onPreviewMyAgendaClick() {
		showPreviewMyAgendaSheet = true
	}
	
	func onPreviewMyAgendaSheetDismiss() {
		showPreviewMyAgendaSheet = false
	}
	
	func onAddToCalendarClick() {
		showAddTocalendarSheet = true
	}

    func onReadMoreClick(eatery: EateriesSlots.Restaurant) {
        let isShipBoard = getSailorShoreOrShipUseCase.execute().isOnShip
        let description = isShipBoard ? eateriesList.resources.diningReservationsShipboardModalSubHeading1.replacingOccurrences(of: "{Restaurant}", with: eatery.name)
        : eateriesList.resources.diningReservationsShipboardModalSubHeading
        infoDrawerModel = InfoDrawerModel(title: eateriesList.resources.diningReservationsShipboardModalHeading, description: description, buttonTitle: eateriesList.resources.gotItCta)
        showSoldOutSheet = true
    }

    func onReadMoreDismiss() {
        showSoldOutSheet = false
    }

    private func loadItineraryDates() async {
        self.itineraryDates = itineraryDatesUseCase.execute()
        let sailorDate = await self.getSailorDateAndTimeUseCase.execute()
        await executeOnMain {
            self.filter.searchSlotDate = itineraryDates.findItineraryDateOrDefault(for: sailorDate)
        }
    }
    
    private func loadEateries() async {
        if let eateriesListResult = await executeUseCase({
			try await self.eateriesListUseCase.execute(includePortsName: true, useCache: true)
		}) {
			await executeOnMain({
				self.eateriesList = eateriesListResult
				self.filter.venues = self.eateriesList.bookable.map({.init(externalId: $0.externalId, venueId: $0.venueId)})
			})
		}
    }
    
	private func loadEateriesSlots() async {
		await executeOnMain({
			self.isEateriesSlotsLoading = true
			self.errorOnLoadingSlots = false
		})
		
		do {
			let result = try await UseCaseExecutor.execute {
				try await self.eateriesSlotsUseCase.execute(input: self.filter)
			}
			
			await executeOnMain({
				self.eateriesWithSlots = result
			})
		} catch {
			await executeOnMain({
				self.errorOnLoadingSlots = true
			})
		}
		
		await executeOnMain({
			self.isEateriesSlotsLoading = false
		})
	}
    
	private func loadAvailableSailors(useCache: Bool) async {
        if let result = await executeUseCase({
			try await self.mySailorsUseCase.execute(useCache: useCache)
        }) {
			await executeOnMain({
				self.availableSailors = result
				self.filter.guests = result.onlyCabinMates()
			})
        }
    }
    
    deinit {
        stopObservingEvents()
    }
}

extension EateriesListScreenViewModel {
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
