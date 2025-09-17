//
//  DocumentDeclarationPreparationViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 24.2.25.
//

import SwiftUI
import Foundation

@Observable
class DocumentDeclarationPreparationViewModel: BaseViewModel, DocumentDeclarationPreparationScreenViewModelProtocol {

    private var coordinator: TravelDocumentsCoordinator
    var document: TravelDocuments.Document = TravelDocuments.Document.empty()
    var scanTravelDocumentUseCase: ScanTravelDocumentUseCaseProtocol
    var screenState: ScreenState = .loading
    var documentDetails: TravelDocumentDetails?
    var landing: TravelDocuments = TravelDocuments.empty()

    init(coordinator: TravelDocumentsCoordinator = AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator, document: TravelDocuments.Document, scanTravelDocumentUseCase: ScanTravelDocumentUseCaseProtocol = ScanTravelDocumentUseCase(), landing: TravelDocuments) {
        self.coordinator = coordinator
        self.document = document
        self.scanTravelDocumentUseCase = scanTravelDocumentUseCase
        self.landing = landing
    }

    func onProceed() {
        guard let documentDetails else { return }
        coordinator.navigationRouter.navigateTo(.documentDetails(details: documentDetails, input: ScanTravelDocumentInputModel.empty(), documentCode: document.code))
    }

    func navigateBack() {
        coordinator.navigationRouter.navigateBack()
    }

    func onClose() {
        coordinator.navigationRouter.navigateTo(.close)
    }
    
    func onAppear() {
        Task{
            await loadTravelDocumentDetails()
        }
    }

                                                
    func loadTravelDocumentDetails() async {
        let input = ScanTravelDocumentInputModel(
            documentCode: document.code,
            categoryCode: document.categoryCode ?? "",
            documentType: document.type,
            ocrValidation: true,
            photoContent: "",
            documentPhotoId: "",
            documentBackPhotoId: "",
            id: nil
        )
        await executeOnMain({
            screenState = .loading
        })
        if let result = await executeUseCase({
            try await self.scanTravelDocumentUseCase.execute(input: input)
        }) {
            await executeOnMain({
                self.documentDetails = result
                screenState = .content
            })
        }
        await executeOnMain({
            screenState = .content
        })
    }

    func onRefresh() {
        Task{
            await loadTravelDocumentDetails()
        }
    }

}
