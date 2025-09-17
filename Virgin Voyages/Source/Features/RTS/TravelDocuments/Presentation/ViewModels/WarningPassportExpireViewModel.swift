//
//  WarningPassportExpireViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 17.6.25.
//

import SwiftUI
import Foundation

@Observable
class WarningPassportExpireViewModel: BaseViewModel, WarningPassportExpireScreenViewModelProtocol {

    private var coordinator: TravelDocumentsCoordinator
    var screenState: ScreenState = .loading
    var document: TravelDocumentDetails
    private let saveTravelDocumentsUseCase: SaveTravelDocumentUseCaseProtocol

    var title: String = ""
    var htmlDescription: String = ""

    init(
        coordinator: TravelDocumentsCoordinator = AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator,
        document: TravelDocumentDetails,
        saveTravelDocumentsUseCase: SaveTravelDocumentUseCaseProtocol = SaveTravelDocumentUseCase()
    ) {
        self.coordinator = coordinator
        self.document = document
        self.saveTravelDocumentsUseCase = saveTravelDocumentsUseCase
        self.title = document.documentExpirationWarnConfig?.title ?? ""
        self.htmlDescription = document.documentExpirationWarnConfig?.description ?? ""
    }
    
    func navigateBack() {
        coordinator.navigationRouter.navigateBack()
    }

    func onAppear() {
        screenState = .content
    }
}
