//
//  DocumentTypeSelectionViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 24.2.25.
//

import SwiftUI
import Foundation
import VVUIKit

@Observable
class DocumentTypeSelectionViewModel: BaseViewModel, DocumentTypeSelectionScreenViewModelProtocol {

    private var coordinator: TravelDocumentsCoordinator
    var documentStage: TravelDocuments.DocumentStage = TravelDocuments.DocumentStage.empty()
    var document: TravelDocuments.Document = TravelDocuments.Document.empty()
    var travelDocuments: TravelDocuments = TravelDocuments.empty()
    private let getTravelDocumentsUseCase: GetTravelDocumentsUseCaseProtocol
    var screenState: ScreenState = .loading
    var canNavigateBack = true
    var isShowingMultiCategorySelection: Bool = false
    var selectedDocument: TravelDocuments.Document = TravelDocuments.Document.empty()
    
    init(coordinator: TravelDocumentsCoordinator = AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator, getTravelDocumentsUseCase: GetTravelDocumentsUseCaseProtocol = GetTravelDocumentsUseCase()) {
        self.coordinator = coordinator
        self.getTravelDocumentsUseCase = getTravelDocumentsUseCase
    }

    func onDocumentSelect(document: TravelDocuments.Document) {
        if document.isMultiCategoryDocument ?? false && !isShowingMultiCategorySelection{
            selectedDocument = document
            isShowingMultiCategorySelection = true
            return
        }
        if document.isAlreadyUploaded {
            coordinator.navigationRouter.navigateTo(.confirmationAlert(document: document, landing: travelDocuments))
            return
        }
        if !(documentStage.isCompleted ?? false) && (document.isCapturable || document.isScanable){
            coordinator.navigationRouter.navigateTo(.documentScanPreparation(document: document, landing: travelDocuments))
            return
        }
        if !(documentStage.isCompleted ?? false) && document.isTwiceSide {
            //TODO: TwiceSide Aditional flow
            return
        }
        coordinator.navigationRouter.navigateTo(.documentDeclarationPreparation(document: document, landing: travelDocuments))
    }

    func onMultiCategoryDocumentSelect(document: TravelDocuments.Document) {
        isShowingMultiCategorySelection = false
        if document.isAlreadyUploaded {
            coordinator.navigationRouter.navigateTo(.confirmationAlert(document: document, landing: travelDocuments))
            return
        }
        if (document.isCapturable || document.isScanable){
            coordinator.navigationRouter.navigateTo(.documentScanPreparation(document: document, landing: travelDocuments))
            return
        }
        coordinator.navigationRouter.navigateTo(.documentDeclarationPreparation(document: document, landing: travelDocuments))
    }
    
    var documentStageWithChoices: TravelDocuments.DocumentStage? {
        return travelDocuments.documentStages.first { $0.isChoisable == true && $0.isCompleted == false}
    }
    
    private func loadTravelDocuments() async {
        if let result = await executeUseCase({
            try await self.getTravelDocumentsUseCase.execute()
        }) {
            self.travelDocuments = result
        }
    }
    
    func navigateBack() {
        coordinator.navigationRouter.navigateBack()
    }

    func onAppear() {
        Task{
            await loadTravelDocuments()
            await executeOnMain({
                if let documentStage = self.documentStageWithChoices{
                    self.documentStage = documentStage
                }
                screenState = .content
            })
        }
    }

    func onRefresh() {
        screenState = .content
    }
    
    func onClose() {
        coordinator.navigationRouter.navigateTo(.close)
    }

}
