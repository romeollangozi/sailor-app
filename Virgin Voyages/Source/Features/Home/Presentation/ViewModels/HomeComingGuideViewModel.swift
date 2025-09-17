//
//  HomeComingGuideViewModel.swift
//  Virgin Voyages
//
//  Created by Pajtim on 2.4.25.
//

import Foundation

@Observable
class HomeComingGuideScreenViewModel: BaseViewModel, HomeComingGuideScreenViewModelProtocol {
	private var homeComingGuideUseCase: GetHomeComingGuideUseCaseProtocol
	private let eateriesListUseCase : GetEateriesListUseCaseProtocol
	private let eateriesSlotsUseCase: GetEateriesSlotsUseCaseProtocol
	private let mySailorsUseCase: GetMySailorsUseCaseProtocol
	private let itineraryDatesUseCase : GetItineraryDatesUseCaseProtocol
	private let friendsEventsNotificationService: FriendsEventsNotificationService
	private let listenerKey = "HomeComingGuideScreenViewModel"
	
	var screenState: ScreenState = .loading
	var homeComingGuide: HomeComingGuide = .empty()
	var eateriesWithSlots : EateriesSlots = .empty()
	var eateriesList: EateriesList = EateriesList.empty()
	var isEateriesSlotsLoading: Bool = false
	var isEateriesListLoading: Bool = false
	var showSlotBookSheet: Bool = false
	var showEditSlotBookSheet: Bool = false
	var filter: EateriesSlotsInputModel = EateriesSlotsInputModel(mealPeriod: .brunch)
	var newBookingViewModel: EaterySlotBookViewModel? = nil
	var editBookingViewModel: EditBookingSheetViewModel? = nil
	var errorOnLoadingSlots: Bool = false
    var showSoldOutSheet: Bool = false
    var infoDrawerModel: InfoDrawerModel = .empty()
    private let getSailorShoreOrShipUseCase: GetSailorShoreOrShipUseCaseProtocol

	init(homeComingGuideUseCase: GetHomeComingGuideUseCaseProtocol = GetHomeComingGuideUseCase(),
		 eateriesListUseCase: GetEateriesListUseCaseProtocol = GetEateriesListUseCase(),
		 eateriesSlotsUseCase: GetEateriesSlotsUseCaseProtocol = GetEateriesSlotsUseCase(),
		 mySailorsUseCase: GetMySailorsUseCaseProtocol = GetMySailorsUseCase(),
		 itineraryDatesUseCase: GetItineraryDatesUseCaseProtocol = GetItineraryDatesUseCase(),
		 friendsEventsNotificationService : FriendsEventsNotificationService = .shared,
         getSailorShoreOrShipUseCase: GetSailorShoreOrShipUseCaseProtocol = GetSailorShoreOrShipUseCase()) {
		self.homeComingGuideUseCase = homeComingGuideUseCase
		self.eateriesListUseCase = eateriesListUseCase
		self.eateriesSlotsUseCase = eateriesSlotsUseCase
		self.mySailorsUseCase = mySailorsUseCase
		self.itineraryDatesUseCase = itineraryDatesUseCase
		self.friendsEventsNotificationService = friendsEventsNotificationService
        self.getSailorShoreOrShipUseCase = getSailorShoreOrShipUseCase

		super.init()
		self.startObservingEvents()
	}
	
	func onViewWalletClick() {
		navigationCoordinator.executeCommand(HomeDashboardCoordinator.OpenWalletCommand())
	}
	
	func onBackClick() {
		navigationCoordinator.executeCommand(HomeDashboardCoordinator.NavigateBackCommand())
	}
	
	func onFirstAppear() {
		Task {
			await loadScreenData()
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
		}
	}
	
	private func loadScreenData() async {
		await loadHomeComingGuide()
		
		screenState = .content
		
		await loadEateriesFirstTime()
	}
	
	private func loadEateriesFirstTime() async {
		await executeOnMain {
			self.isEateriesListLoading = true
			self.filter.searchSlotDate = itineraryDatesUseCase.execute().last?.date ?? Date()
		}
		
		await loadAvailableSailors(useCache: true)
		
		await loadEateries()
		
		await loadEateriesSlots()
		
		await executeOnMain {
			let eatriesWithAvailableSlots = eateriesWithSlots.onlyThoseWithTimeslotsAvailable()
			let onlyBookableWithSlots = eateriesList.findBookables(externalIds: eatriesWithAvailableSlots.restaurants.map({$0.externalId}))
			
			self.eateriesList = self.eateriesList.copy(bookable: onlyBookableWithSlots)
			self.filter.venues = self.eateriesList.bookable.map({.init(externalId: $0.externalId, venueId: $0.venueId)})
			self.isEateriesListLoading = false
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

	
	func onSlotBookSheetDismissed() {
		hideSlotBookSheet()
	}
	
	private func hideSlotBookSheet() {
		self.newBookingViewModel = nil
		self.showSlotBookSheet = false
	}
	
	func onBookCompleted() {
		hideSlotBookSheet()
		
		Task {
			await loadEateriesSlots()
		}
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
	
	func onEditBookingCompleted() {
		hideEditBookSheet()
		
		Task {
			await loadEateriesSlots()
		}
	}
	
	func onBookingCanceled() {
		hideEditBookSheet()
		
		Task {
			await loadEateriesSlots()
		}
	}
	
	func onEditBookingSheetDismissed() {
		hideEditBookSheet()
	}
	
	private func hideEditBookSheet() {
		self.showEditSlotBookSheet = false
		self.editBookingViewModel = nil
	}
	
	func onEateryClick(eatery: EateriesList.Eatery) {
		navigationCoordinator.executeCommand(HomeDashboardCoordinator.OpenDiningDetailsScreenCommand(slug: eatery.slug, filter: self.filter))
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

	private func loadAvailableSailors(useCache: Bool) async {
		if let availableSailors =  await executeUseCase({
			try await self.mySailorsUseCase.execute(useCache: useCache)
		}) {
			await executeOnMain({
				self.filter.guests = availableSailors.onlyCabinMates()
			})
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
	
	private func loadHomeComingGuide() async {
		if let result = await executeUseCase({
			try await self.homeComingGuideUseCase.execute()
		}) {
			await executeOnMain({
				self.homeComingGuide = result
			})
		} else {
			await executeOnMain({
				self.screenState = .error
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
	
	deinit {
		stopObservingEvents()
	}
}

extension HomeComingGuideScreenViewModel {
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
