//
//  DeleteDocumentViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 21.3.25.
//

import Foundation

final class DeleteDocumentViewModel: BaseViewModel, DeleteDocumentScreenViewModelProtocol {
    
    private var coordinator: TravelDocumentsCoordinator
    private let deleteDocumentsUseCase: DeleteDocumentUseCaseProtocol
    var document: TravelDocumentDetails
    var documentName: String { document.title }
    var screenState: ScreenState = .content
    var fieldValues: [String: String] = [:]
    var isTypeVisa: Bool
    
    init(coordinator: TravelDocumentsCoordinator = AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator, deleteDocumentsUseCase: DeleteDocumentUseCaseProtocol = DeleteDocumentUseCase(), document: TravelDocumentDetails, isTypeVisa: Bool) {
        self.coordinator = coordinator
        self.deleteDocumentsUseCase = deleteDocumentsUseCase
        self.document = document
        self.isTypeVisa = isTypeVisa
    }
    
    func deleteDocument() async {
        await executeOnMain({
            screenState = .loading
        })
        if let _ = await executeUseCase({
            try await self.deleteDocumentsUseCase.execute(input: self.document.toInputModel(isVisa: self.isTypeVisa))
        }) {
            
        }
        await executeOnMain({
            self.coordinator.navigationRouter.goToRoot()
            self.screenState = .content
        })
    }

    func onConfirmDelete() {
        Task{
            await self.deleteDocument()
        }
    }

    func onCancel() {
        self.coordinator.navigationRouter.navigateBack()
    }
    
}
