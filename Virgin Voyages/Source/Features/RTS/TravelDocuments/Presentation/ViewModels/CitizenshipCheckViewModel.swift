//
//  CitizenshipCheckViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 18.2.25.
//

import SwiftUI
import Foundation
import VVUIKit

@Observable
class CitizenshipCheckViewModel: BaseViewModel, CitizenshipCheckScreenViewModelProtocol {
    private var coordinator: TravelDocumentsCoordinator
    private let getTravelDocumentsUseCase: GetTravelDocumentsUseCaseProtocol
    var travelDocuments: TravelDocuments = TravelDocuments.empty()

    var screenState: ScreenState = .loading

    init(coordinator: TravelDocumentsCoordinator = AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator, getTravelDocumentsUseCase: GetTravelDocumentsUseCaseProtocol = GetTravelDocumentsUseCase()) {
        self.coordinator = coordinator
        self.getTravelDocumentsUseCase = getTravelDocumentsUseCase
    }

    func onProceed() {
        if travelDocuments.citizenshipType == .rulesAreNotDefined{
            coordinator.navigationRouter.navigateTo(.close)
            return
        }
        
        if travelDocuments.citizenshipType == .unknown {
            coordinator.navigationRouter.navigateTo(.citizenshipSelection)
            return
        }
        
        if let documentStageWithChoices = documentStageWithChoices, !shouldSkipDocumentTypeSelection {
            coordinator.navigationRouter.navigateTo(.documentTypeSelection())
            return
        }

        if documentStagesCompleted && hasPostVoyagePlanes {
            coordinator.navigationRouter.navigateTo(.postVoyagePlanes)
            return
        }
        
        if documentStagesCompleted {
            coordinator.navigationRouter.navigateTo(.documentReview)
            return
        }
        
        if let documentStage = nextDocumentStage, let document = documentStage.documents.first {
            if document.isAlreadyUploaded {
                coordinator.navigationRouter.navigateTo(.confirmationAlert(document: document, landing: travelDocuments))
                return
            }
            if (document.isCapturable || document.isScanable) {
                coordinator.navigationRouter.navigateTo(.documentScanPreparation(document: document, landing: travelDocuments))
                return
            }
            if document.isTwiceSide {
                coordinator.navigationRouter.navigateTo(.documentScanPreparation(document: document, landing: travelDocuments))
                return
            }
            coordinator.navigationRouter.navigateTo(.documentDeclarationPreparation(document: document, landing: travelDocuments))

        }
    }

    var hasPostVoyagePlanes: Bool {
        return travelDocuments.hasPostVoyagePlans
    }
    
    var documentStageWithChoices: TravelDocuments.DocumentStage? {
        return travelDocuments.documentStages.first { $0.isChoisable == true && $0.isCompleted == false}
    }

    var nextDocumentStage: TravelDocuments.DocumentStage? {
        return travelDocuments.documentStages.first {$0.isCompleted == false}
    }

    var hasAnyStageCompleted: Bool {
        travelDocuments.documentStages.contains { $0.isCompleted == true }
    }
    
    var shouldSkipDocumentTypeSelection: Bool {
        if let firstIncomplete = travelDocuments.documentStages.first(where: { $0.isCompleted == false }) {
            return firstIncomplete.isChoisable == false
        }
        return false
    }
    
    var documentStagesCompleted: Bool {
        return travelDocuments.documentStages.allSatisfy { $0.isCompleted == true }
    }

    func onClose() {
        coordinator.navigationRouter.navigateTo(.close)
    }

    func onAppear() async {
        await executeOnMain({
            screenState = .loading
        })
        await loadTravelDocuments()
        await executeOnMain({
            if travelDocuments.citizenshipType == .rulesAreNotDefined{
                screenState = .content
                return
            }
            if travelDocuments.citizenshipType == .unknown {
                screenState = .content
                return
            }
            if documentStagesCompleted && hasPostVoyagePlanes {
                coordinator.navigationRouter.navigateTo(.postVoyagePlanes)
                return
            }
            if documentStagesCompleted {
                coordinator.navigationRouter.navigateTo(.documentReview)
                return
            }

            if hasAnyStageCompleted{
                if travelDocuments.citizenshipType == .rulesAreNotDefined{
                    coordinator.navigationRouter.navigateTo(.close)
                    return
                }
                
                if let documentStageWithChoices = documentStageWithChoices, !shouldSkipDocumentTypeSelection {
                    coordinator.navigationRouter.navigateTo(.documentTypeSelection(canNavigateBack: false))
                    return
                }
                self.onProceed()
                return
            }
            screenState = .content
        })
    }

    func onRefresh() async {
        await loadTravelDocuments()
        screenState = .content
    }

    private func loadTravelDocuments() async {
        if let result = await executeUseCase({
            try await self.getTravelDocumentsUseCase.execute()
        }) {
            self.travelDocuments = result
        }
    }
}
