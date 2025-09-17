//
//  ConfirmOrReplaceDocumentViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 1.4.25.
//

import Foundation

@Observable
class ConfirmOrReplaceDocumentViewModel: BaseViewModel, ConfirmOrReplaceDocumentScreenViewModelProtocol {
    
    private var coordinator: TravelDocumentsCoordinator
    var document: TravelDocuments.Document
    var landing: TravelDocuments
    var documentName: String { document.name }
    var screenState: ScreenState = .content
    var scanTravelDocumentUseCase: ScanTravelDocumentUseCaseProtocol
    
    init(
        coordinator: TravelDocumentsCoordinator = AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator,
        scanTravelDocumentUseCase: ScanTravelDocumentUseCaseProtocol = ScanTravelDocumentUseCase(),
        document: TravelDocuments.Document,
        landing: TravelDocuments
    ) {
        self.coordinator = coordinator
        self.scanTravelDocumentUseCase = scanTravelDocumentUseCase
        self.document = document
        self.landing = landing
    }
    
    func onReplaceDocument() {
        if document.isCapturable || document.isScanable{
            coordinator.navigationRouter.navigateTo(.documentScanPreparation(document: document, landing: landing))
        }else {
            coordinator.navigationRouter.navigateTo(.documentDeclarationPreparation(document: document, landing: landing))
        }
    }
    
    func onCancel() {
        coordinator.navigationRouter.navigateTo(.close)
    }
    
    func onUseExistingDocument() {
        screenState = .content
        Task {
            if let details = await loadTravelDocumentDetails() {
                coordinator.navigationRouter.navigateTo(.documentDetails(details: details, input: ScanTravelDocumentInputModel.empty(), documentCode: document.code))
            }
        }
    }
    
    func loadTravelDocumentDetails() async -> TravelDocumentDetails? {
        let input = ScanTravelDocumentInputModel(
            documentCode: document.code,
            categoryCode: document.categoryCode ?? "",
            documentType: document.type,
            ocrValidation: true,
            photoContent: nil,
            documentPhotoId: nil,
            documentBackPhotoId: nil,
            id: document.documentId
        )
        
        screenState = .loading
        if let result = await executeUseCase({
            try await self.scanTravelDocumentUseCase.execute(input: input)
        }) {
            return result
        }
        screenState = .content
        return nil
    }
}
