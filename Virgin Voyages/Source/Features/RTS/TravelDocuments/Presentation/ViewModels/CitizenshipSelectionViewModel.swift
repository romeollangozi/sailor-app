//
//  CitizenshipSelectionViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 8.9.25.
//

import SwiftUI
import Foundation
import VVUIKit

@Observable
final class CitizenshipSelectionViewModel: BaseViewModelV2, CitizenshipSelectionScreenViewModelProtocol {

    // MARK: - Dependencies
    private let coordinator: TravelDocumentsCoordinator
    private let saveCitizenshipUseCase: SaveCitizenshipUseCaseProtocol
    private let getLookupUseCase: GetLookupUseCaseProtocol
    var countries: [Option] = []
    var lookupSource: Lookup = .empty()

    // MARK: - UI Content
    var title: String = "Citizenship"
    var subtitle: String = "Please select your Citizenship so we can determine the travel docs required for your itinerary"
    var actionText: String = "Please select your citizenship"
    var placeholder: String = "Citizenship"
    var buttonTitle: String = "Next"

    // MARK: - Screen State
    var screenState: ScreenState = .loading

    // MARK: - Data
    var selectedCountryCode: String?
    var selectedCountryBinding: Binding<String?> {
           Binding(
               get: { self.selectedCountryCode },
               set: { self.selectedCountryCode = $0 }
           )
       }

    // MARK: - Init
    init(
        coordinator: TravelDocumentsCoordinator = AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator,
        saveCitizenshipUseCase: SaveCitizenshipUseCaseProtocol = SaveCitizenshipUseCase(), getLookupUseCase: GetLookupUseCaseProtocol = GetLookupUseCase(),
        countries: [Option] = []
    ) {
        self.coordinator = coordinator
        self.saveCitizenshipUseCase = saveCitizenshipUseCase
        self.getLookupUseCase = getLookupUseCase
        self.countries = countries
        super.init()
    }

    // MARK: - Lifecycle
    func onAppear() async {
        await loadLookupOptions()
        self.screenState = .content
    }

    func onRefresh() async {
        await onAppear()
    }

    // MARK: - Actions
    
    func onProceed() {
        guard let code = selectedCountryCode?.trimmingCharacters(in: .whitespacesAndNewlines),
              !code.isEmpty else {
            return
        }

        Task {
           self.screenState = .loading

            let input = CitizenshipModel(
                citizenshipCountryCode: code,
                reservationGuestId: nil
            )

            if let _ = await executeUseCase({
                try await self.saveCitizenshipUseCase.execute(input: input)
            }) {
                self.screenState = .content
                coordinator.navigationRouter.navigateTo(.documentTypeSelection(canNavigateBack: false))
                return
            }
            
            self.screenState = .content
        }
    }

    func loadLookupOptions() async {
        if let result = await executeUseCase({
            try await self.getLookupUseCase.execute()
        }) {
            self.lookupSource = result
            let lookupOptions = result.toLookupOptionsDictionary()
            self.countries = lookupOptions[Lookup.countiesKey] ?? []
        }
        screenState = .content
    }
    
    func onBack() {
        coordinator.navigationRouter.navigateBack()
    }
    
}
