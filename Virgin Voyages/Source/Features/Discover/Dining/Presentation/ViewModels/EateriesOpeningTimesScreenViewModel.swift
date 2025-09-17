//
//  EateriesOpeningTimesScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 3.12.24.
//

import Foundation


@Observable class EateriesOpeningTimesScreenViewModel : BaseViewModel, EateriesOpeningTimesScreenViewModelProtocol {

    private let eateriesOpeningTimesUseCase: GetEateriesOpeningTimesUseCaseProtocol
	
    var screenState: ScreenState = .loading
    var itineraryDates: [Date]
    var selectedDate: Date = Date()
    var eateriesOpeningTimes: EateriesOpeningTimesModel = EateriesOpeningTimesModel.empty
       
    init(eateriesOpeningTimesUseCase: GetEateriesOpeningTimesUseCaseProtocol = GetEateriesOpeningTimesUseCase(), itineraryDatesUseCase: GetItineraryDatesUseCaseProtocol = GetItineraryDatesUseCase()) {
		
		let itineraryDates = itineraryDatesUseCase.execute()
		
		self.itineraryDates = itineraryDates.getDates()
		self.selectedDate = itineraryDates.findItineraryDateOrDefault(for: Date())
        self.eateriesOpeningTimesUseCase = eateriesOpeningTimesUseCase
    }
    
    func onAppear() {
        Task {
            await loadOpeningTimes()
            
            self.screenState = .content
        }
    }
    
    func onRefresh() {
        Task {
            await loadOpeningTimes()
            
            self.screenState = .content
        }
    }
    
    func onDateChanged() {
        Task {
            await loadOpeningTimes()
        }
    }
    
    private func loadOpeningTimes() async {
		if let result = await executeUseCase({try await self.eateriesOpeningTimesUseCase.execute(date: self.selectedDate)}) {
            eateriesOpeningTimes = result
        }
    }
}
