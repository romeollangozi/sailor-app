//
//  EateryDetailsScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 30.11.24.
//

import Foundation

@Observable class EateryDetailsScreenViewModel : BaseViewModel, EateryDetailsScreenViewModelProtocol {
	private let eateryDetailsUseCase : GetEateryDetailsUseCaseProtocol
	private let eateriesSlotsUseCase: GetEateriesSlotsUseCaseProtocol
	private let mySailorsUseCase: GetMySailorsUseCaseProtocol
	private let friendsEventsNotificationService: FriendsEventsNotificationService
	private let listenerKey = "EateryDetailsScreenViewModel"
	
	private let slug: String
	
	var screenState: ScreenState = .loading
	var eateryWithSlots: EateriesSlots.Restaurant? = nil
	
	var eateryDetails: EateryDetailsModel = EateryDetailsModel.empty()
	var filter: EateriesSlotsInputModel
	var itineraryDates: [Date]
	var isEateriesSlotsLoading: Bool = false
	var showFilterSheet: Bool = false
	var showSlotBookSheet = false
	var availableSailors: [SailorModel] = []
	var showEditSlotBookSheet: Bool = false
	var showAddTocalendarSheet: Bool = false
    var showPDFMenuViewer: Bool = false
    var pdfMenuUrl: URL?
	var newBookingViewModel: EaterySlotBookViewModel? = nil
	var editBookingViewModel: EditBookingSheetViewModel? = nil
	var errorOnLoadingSlots: Bool = false
    var showSoldOutSheet: Bool = false
    var infoDrawerModel: InfoDrawerModel = .empty()
    private let getSailorShoreOrShipUseCase: GetSailorShoreOrShipUseCaseProtocol
    private var isShipBoard = false
    private let dateTimeRepository: DateTimeRepositoryProtocol
    private var dateTime = Date()
    var editorialBlocks: [EditorialBlock] = []
    private let htmlFetcherService: HTMLFetcherServiceProtocol

	init(slug: String,
		 filter: EateriesSlotsInputModel? = nil,
		 eateryDetailsUseCase: GetEateryDetailsUseCaseProtocol = GetEateryDetailsUseCase(),
		 eateriesSlotsUseCase: GetEateriesSlotsUseCaseProtocol = GetEateriesSlotsUseCase(),
		 mySailorsUseCase: GetMySailorsUseCaseProtocol = GetMySailorsUseCase(),
		 itineraryDatesUseCase: GetItineraryDatesUseCaseProtocol = GetItineraryDatesUseCase(),
		 friendsEventsNotificationService : FriendsEventsNotificationService = .shared,
         getSailorShoreOrShipUseCase: GetSailorShoreOrShipUseCaseProtocol = GetSailorShoreOrShipUseCase(),
         dateTimeRepository: DateTimeRepositoryProtocol = DateTimeRepository(),
         htmlFetcherService: HTMLFetcherServiceProtocol = HTMLFetcherService()) {
		self.slug = slug
		
		self.eateryDetailsUseCase = eateryDetailsUseCase
		self.eateriesSlotsUseCase = eateriesSlotsUseCase
		self.mySailorsUseCase = mySailorsUseCase
		self.friendsEventsNotificationService = friendsEventsNotificationService
        self.getSailorShoreOrShipUseCase = getSailorShoreOrShipUseCase
        self.dateTimeRepository = dateTimeRepository
        self.htmlFetcherService = htmlFetcherService

		let itineraryDates = itineraryDatesUseCase.execute()
		self.itineraryDates = itineraryDatesUseCase.execute().getDates()
		self.filter = filter ?? EateriesSlotsInputModel(searchSlotDate: itineraryDates.findItineraryDateOrDefault(for: Date()),
														mealPeriod: MealPeriod.dinner,
														venues:[],
														guests: [])
		
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
		await loadEateryDetails()
        await loadEditorialBlocks()

		if eateryDetails.isBookable {
			await loadAvailableSailors()
			
			await loadEaterySlots()
		}
        isShipBoard = getSailorShoreOrShipUseCase.execute().isOnShip
        dateTime = await dateTimeRepository.fetchDateTime().getCurrentDateTime()

		self.screenState = .content
	}
	
	func onDateChanged() {
		Task {
			await loadEaterySlots()
		}
	}
	
	func onFilterChanged(date: Date, mealPeriod: MealPeriod, selectedSailors: [SailorModel]) {
		self.filter.searchSlotDate = date
		self.filter.mealPeriod = mealPeriod
		self.filter.guests = selectedSailors
		
		self.showFilterSheet = false
		
		Task {
			await loadEaterySlots()
		}
	}
	
	func onFilterButtonClick() {
		showFilterSheet = true
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
	
	private func hideSlotBookSheet() {
		newBookingViewModel = nil
		showSlotBookSheet = false
	}
	
	func onBookCompleted() {
		hideSlotBookSheet()
		
		Task {
			await loadEaterySlots()
		}
	}
	
	func onNewBookingSheetDismiss() {
		hideSlotBookSheet()
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
			await loadEaterySlots()
		}
	}
	
	func onEditBookingSheetDismiss() {
		hideEditBookSheet()
	}
	
	func onBookingCanceled() {
		hideEditBookSheet()
		
		Task {
			await loadEaterySlots()
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
	
	func onAddToCalendarClick() {
		showAddTocalendarSheet = true
	}

    func onReadMoreClick(eatery: EateriesSlots.Restaurant) {
        let description = isShipBoard ? eateryDetails.resources.diningReservationsShipboardModalSubHeading1.replacingOccurrences(of: "{Restaurant}", with: eatery.name)
        : eateryDetails.resources.diningReservationsShipboardModalSubHeading
        infoDrawerModel = InfoDrawerModel(title: eateryDetails.resources.diningReservationsShipboardModalHeading, description: description, buttonTitle: eateryDetails.resources.gotItCta)
        showSoldOutSheet = true
    }

    func onReadMoreDismiss() {
        showSoldOutSheet = false
    }

    var openingTimesTitle: String {
        if !isShipBoard {
            return "Opening times"
        }

        let status = eateryDetails.openingTimes.status(for: dateTime)

        switch status {
        case .open(let until):
            return "Open • till \(until)"
        case .closed:
            return "Closed"
        }
    }

	private func loadEateryDetails() async {
		if let result = await executeUseCase({
			try await self.eateryDetailsUseCase.execute(slug: self.slug, useCache: true)
		}) {
			await executeOnMain {
				self.eateryDetails = result
				self.filter.venues = [.init(externalId: result.externalId, venueId: result.venueId)]
			}
		} else {
			await executeOnMain {
				self.screenState = .error
			}
		}
	}
		
	private func loadEaterySlots() async {
		await executeOnMain({
			self.isEateriesSlotsLoading = true
			self.errorOnLoadingSlots = false
		})
		
		do {
			let result = try await UseCaseExecutor.execute {
				try await self.eateriesSlotsUseCase.execute(input: self.filter)
			}
			
			await executeOnMain({
				self.eateryWithSlots = result.restaurants.first
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
	
	private func loadAvailableSailors(useCache: Bool = true) async {
		if let result = await executeUseCase({
			try await self.mySailorsUseCase.execute(useCache: useCache)
		}) {
			await executeOnMain {
				self.availableSailors = result
			}
		} else {
			await executeOnMain {
				self.screenState = .error
			}
		}
	}

    var isMenuClickable: Bool {
        if let menuPdf = eateryDetails.menuData?.menuPdf, let pdfUrl = URL(string: menuPdf), !menuPdf.isEmpty {
            return true
        }
        return false
    }

    func onOpenMenu() {
        if let menuPdf = eateryDetails.menuData?.menuPdf, let pdfUrl = URL(string: menuPdf), !menuPdf.isEmpty {
            pdfMenuUrl = pdfUrl
            self.showPDFMenuViewer = true
        }
    }
	
	deinit {
		stopObservingEvents()
	}
}

extension EateryDetailsScreenViewModel {
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

extension EateryDetailsScreenViewModel {
    @MainActor
    func loadEditorialBlocks() async {
        for url in eateryDetails.editorialBlocks {
            let html = await htmlFetcherService.fetchHTML(from: url)
            editorialBlocks.append(EditorialBlock(url: url, html: html))
        }
    }
}
