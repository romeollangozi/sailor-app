//
//  PreviewMyAgendaSheetViewModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 3.4.25.
//

import Foundation

@Observable class PreviewMyAgendaSheetViewModel : BaseViewModelV2, PreviewMyAgendaSheetViewModelProtocol {
	var screenState: ScreenState = .loading
	var myVoyageAgenda: MyVoyageAgenda = .empty()
	var date: Date
	var portName: String? {
		let itineraryDates = itineraryDatesUseCase.execute()
		guard let itinerary = itineraryDates.findItinerary(for: date) else {
			return nil
		}
		return itinerary.isSeaDay ? "Sea day" : itinerary.portName
	}

	private let getMyVoyageAgendaUseCase: GetMyVoyageAgendaUseCaseProtocol
	private let itineraryDatesUseCase : GetItineraryDatesUseCaseProtocol
    private var localizationManager: LocalizationManagerProtocol
    var resources: MyAgendaLocalizationResources = .defaultResources()

	init(date: Date,
		 getMyVoyageAgendaUseCase: GetMyVoyageAgendaUseCaseProtocol = GetMyVoyageAgendaUseCase(),
		 itineraryDatesUseCase: GetItineraryDatesUseCase = GetItineraryDatesUseCase(),
         localizationManager: LocalizationManagerProtocol = LocalizationManager.shared) {
		self.date = date
		self.getMyVoyageAgendaUseCase = getMyVoyageAgendaUseCase
		self.itineraryDatesUseCase = itineraryDatesUseCase
        self.localizationManager = localizationManager

        super.init()
        loadLocalizationResources()
	}
	
	func onAppear() {
		Task {
			await loadMyVoyageAgenda()
			self.screenState = .content
		}
	}
	
	func onRefresh() {
		Task {
			await loadMyVoyageAgenda(useCache: false)
			self.screenState = .content
		}
	}
	
	private func loadMyVoyageAgenda(useCache: Bool = true) async {
		if let result = await executeUseCase({
			try await self.getMyVoyageAgendaUseCase.execute(useCache: useCache)
		}) {
			self.myVoyageAgenda = result.copy(appointments: result.appointments.filter { isSameDay(date1: $0.date, date2: self.date) })
		}
	}

    private func loadLocalizationResources() {
        resources = MyAgendaLocalizationResources(
            emptyAgendaMessage: localizationManager.getString(for: .emptyAgendaMessage),
            yourPreviewAgendaText: localizationManager.getString(for: .yourPreviewAgendaText),
            portDayLabel: localizationManager.getString(for: .portDayLabel).replacingOccurrences(of: "{Port Name}", with: portName ?? "")
        )
    }
}
