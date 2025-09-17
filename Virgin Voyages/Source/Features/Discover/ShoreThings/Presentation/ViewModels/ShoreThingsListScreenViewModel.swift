//
//  ShoreThingsListScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 15.5.25.
//

import SwiftUI

@Observable class ShoreThingsListScreenViewModel: BaseViewModel, ShoreThingsListScreenViewModelProtocol {
	private let getShoreThingsListUseCase: GetShoreThingsListUseCaseProtocol
	private var bookingEventsNotificationService: BookingEventsNotificationService
	private var listenerKey = "ShoreThingsListScreenViewModel"
	
	private let portCode: String
	private let arrivalDateTime, departureDateTime: Date?

	var screenState: ScreenState = .loading
	var shoreThingsList: ShoreThingsList = .empty()
	var selectedType: ShoreThingsListType? = nil
	var searchableItems: [ShoreThingItem] = []
	
	init(portCode: String,
		 arrivalDateTime: Date?,
		 departureDateTime: Date?,
		 getShoreThingsListUseCase: GetShoreThingsListUseCaseProtocol = GetShoreThingsListUseCase(),
		 bookingEventsNotificationService: BookingEventsNotificationService = .shared
	) {
		self.portCode = portCode
		self.arrivalDateTime = arrivalDateTime
		self.departureDateTime = departureDateTime

		self.getShoreThingsListUseCase = getShoreThingsListUseCase
		self.bookingEventsNotificationService = bookingEventsNotificationService
		
		super.init()
		self.startObservingEvents()
	}
	
	func onAppear() {
		Task {
			await loadShoreThings()
		}
	}
	
	func onRefresh() {
		Task {
			await loadShoreThings()
		}
	}
	
	private func loadShoreThings(useCache: Bool = true) async {
		if let result = await executeUseCase({
			try await self.getShoreThingsListUseCase.execute(portCode: self.portCode,
															 arrivalDateTime: self.arrivalDateTime,
															 departureDateTime: self.departureDateTime,
															 useCache: useCache)
		}) {
			await executeOnMain({
				self.shoreThingsList = result
				self.searchableItems = result.items
				self.screenState = .content
			})
		} else {
			await executeOnMain({
				self.screenState = .error
			})
		}
	}
	
	func onTypeTapped(_ type: ShoreThingsListType) {
		if selectedType == type {
			selectedType = nil
		} else {
			selectedType = type
		}
		
		self.searchableItems = selectedType != nil
		? self.shoreThingsList.items.filter({ $0.types.contains(type.code) })
		: self.shoreThingsList.items
	}
	
	func getExcursionsText() -> String {
		let excursionWord = searchableItems.count == 1 ? "excursion" : "excursions"
		return "\(searchableItems.count) \(excursionWord)"
	}
	
	deinit {
		stopObservingEvents()
	}
}

// MARK: - Event Handling
extension ShoreThingsListScreenViewModel {

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
		case .userDidMakeABooking, .userDidUpdateABooking, .userDidCancelABooking:
			Task {
				await loadShoreThings(useCache: false)
			}
		}
	}
}
