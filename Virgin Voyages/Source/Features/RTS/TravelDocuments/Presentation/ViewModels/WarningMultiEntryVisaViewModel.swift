//
//  WarningMultiEntryVisaViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 19.3.25.
//

import SwiftUI
import Foundation

@Observable
class WarningMultiEntryVisaViewModel: BaseViewModel, WarningMultiEntryVisaScreenViewModelProtocol {

    private var coordinator: TravelDocumentsCoordinator
    var screenState: ScreenState = .loading
    var document: TravelDocumentDetails

    init(coordinator: TravelDocumentsCoordinator = AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator, document: TravelDocumentDetails) {
        self.coordinator = coordinator
        self.document = document
    }

    func onDelete() {
        coordinator.navigationRouter.navigateTo(.deleteDocument(document: document, isTypeVisa: true))
    }
    
    func navigateBack() {
        coordinator.navigationRouter.navigateBack()
    }

    func onAppear() {
        screenState = .content
    }
}
