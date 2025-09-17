//
//  CabinServiceOpeningTimeScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 3.5.25.
//


import Foundation

@Observable class CabinServiceOpeningTimeScreenViewModel: BaseViewModel, CabinServiceOpeningTimeScreenViewModelProtocol {
	private let getCabinServiceOpeningTimeUseCase: GetCabinServiceOpeningTimeUseCaseProtocol
	
	var screenState: ScreenState = .loading
	var cabinServiceOpenTime: CabinServiceOpeninTime = .empty()
	
	init(getCabinServiceOpeningTimeUseCase: GetCabinServiceOpeningTimeUseCaseProtocol = GetCabinServiceOpeningTimeUseCase()) {
		self.getCabinServiceOpeningTimeUseCase = getCabinServiceOpeningTimeUseCase
	}
	
	func onAppear() {
		Task {
			await loadData()
		}
	}
	
	func onRefresh() {
		Task {
			await loadData()
		}
	}
	
	func onBackTapped() {
		executeNavigationCommand(ServiceCoordinator.ServiceBackCommand())
	}
	
	private func loadData() async {
		if let result = await executeUseCase({
			try await self.getCabinServiceOpeningTimeUseCase.execute()
		}) {
			await executeOnMain({
				self.cabinServiceOpenTime = result
				self.screenState = .content
			})
		} else {
			await executeOnMain({
				self.screenState = .error
			})
		}
	}
}
