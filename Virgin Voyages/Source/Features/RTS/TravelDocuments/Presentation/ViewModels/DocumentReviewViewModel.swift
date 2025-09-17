//
//  DocumentReviewViewModel.swift
//  Virgin Voyages
//
//  Created by Pajtim on 14.3.25.
//

import Foundation

@Observable
class DocumentReviewViewModel: BaseViewModel, DocumentReviewViewModelProtocol {

    private var coordinator: TravelDocumentsCoordinator
    var screenState: ScreenState = .loading
    var getMyDocumentsUseCaseProtocol: GetMyDocumentsUseCaseProtocol
    var scanTravelDocumentUseCase: ScanTravelDocumentUseCaseProtocol
    var myDocuments: MyDocuments = MyDocuments.empty()

    init(coordinator: TravelDocumentsCoordinator = AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator, getMyDocumentsUseCaseProtocol: GetMyDocumentsUseCaseProtocol = GetMyDocumentsUseCase(), scanTravelDocumentUseCase: ScanTravelDocumentUseCaseProtocol = ScanTravelDocumentUseCase()) {
        self.coordinator = coordinator
        self.getMyDocumentsUseCaseProtocol = getMyDocumentsUseCaseProtocol
        self.scanTravelDocumentUseCase = scanTravelDocumentUseCase
    }

    func onAppear() {
        Task {
            await getMyDocuments()
        }
    }

    func navigateBack() {
        coordinator.navigationRouter.navigateBack()
    }

    func onClose() {
        coordinator.navigationRouter.navigateTo(.close)
    }

    func navigateToDetails(from document: MyDocuments.Document) {
        Task {
            if let details = await loadTravelDocumentDetails(from: document) {
                coordinator.navigationRouter.navigateTo(.documentDetails(details: details, input: ScanTravelDocumentInputModel.empty(), isEditing: true, documentCode: document.documentCode))
            }
        }
    }

    func getMyDocuments() async {
        screenState = .loading
        if let result = await executeUseCase({
            try await self.getMyDocumentsUseCaseProtocol.execute()
        }) {
            self.myDocuments = result
        }
        screenState = .content
    }

    fileprivate func loadTravelDocumentDetails(from document: MyDocuments.Document) async -> TravelDocumentDetails? {
        let input = ScanTravelDocumentInputModel(
            documentCode: document.documentCode,
            categoryCode: document.categoryCode,
            documentType: document.documentType,
            ocrValidation: true,
            photoContent: nil,
            documentPhotoId: nil,
            documentBackPhotoId: nil,
            id: document.id
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
    
    func navigateToPostVoyagePlanes(){
        coordinator.navigationRouter.navigateTo(.postVoyagePlanes)
    }
}
