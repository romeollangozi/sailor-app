//
//  HomeItineraryDetailsSheetViewModel.swift
//  Virgin Voyages
//
//  Created by Pajtim on 7.4.25.
//

import Foundation

protocol HomeItineraryDetailsSheetViewModelProtocol {
    var homeItineraryDetails: HomeItineraryDetails { get }
    var screenState: ScreenState { get set }
    func onAppear()
    func dismissSheet()
}

@Observable
class HomeItineraryDetailsSheetViewModel: BaseViewModel, HomeItineraryDetailsSheetViewModelProtocol {

    private var appCoordinator: AppCoordinator = .shared
    private var homeItineraryDetailsUseCase: GetHomeItineraryDetailsUseCaseProtocol
    var homeItineraryDetails: HomeItineraryDetails
    var screenState: ScreenState = .loading

    init(homeItineraryDetails: HomeItineraryDetails = .empty(), homeItineraryDetailsUseCase: GetHomeItineraryDetailsUseCaseProtocol = GetHomeItineraryDetailsUseCase()) {
        self.homeItineraryDetails = homeItineraryDetails
        self.homeItineraryDetailsUseCase = homeItineraryDetailsUseCase
    }

    func dismissSheet() {
        appCoordinator.executeCommand(HomeDashboardCoordinator.DismissAnyDashboardSheetCommand())
    }

    func onAppear() {
        Task {
            await loadHomeItineraryDetails()
        }
    }

    private func loadHomeItineraryDetails() async {
        if let result = await executeUseCase({
            try await self.homeItineraryDetailsUseCase.execute()
        }) {
            await executeOnMain {
                self.homeItineraryDetails = result
                screenState = .content
            }
        } else {
            await executeOnMain {
                screenState = .error
            }
        }
    }
}
